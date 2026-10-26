import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// ARB 정합성. 순수 Dart 로 파일을 읽어 대조한다.
/// 언어 목록은 lib/l10n/app_*.arb 에서 모은다.
final _langs = [
  for (final f in Directory('lib/l10n').listSync().whereType<File>())
    if (RegExp(r'app_(\w+)\.arb$').firstMatch(f.path) case final m?)
      m.group(1)!,
]..sort();

/// 번역 대상이 아닌 브랜드 키.
const _brandKeys = {'appBadge', 'appTitle', 'footer'};

/// en 과 반드시 달라야 하는 핵심 키.
const _coreKeys = {'newGame', 'settings', 'records', 'cancel', 'undo'};

/// 값의 80% 이상이 이 문자 범위를 포함해야 하는 언어.
const _scripts = {
  'ar': r'؀-ۿ',
  'he': r'֐-׿',
  'hi': r'ऀ-ॿ',
  'th': r'฀-๿',
  'el': r'Ͱ-Ͽ',
  'ru': r'Ѐ-ӿ',
  'uk': r'Ѐ-ӿ',
  'ja': r'぀-ヿ一-鿿',
  'zh': r'一-鿿',
  'zh_Hant': r'一-鿿',
  'ko': r'가-힣',
};

/// other 외에 반드시 있어야 하는 복수형 범주.
const _pluralCategories = {
  'ru': ['few', 'many'],
  'uk': ['few', 'many'],
  'pl': ['few', 'many'],
  'cs': ['few'],
  'sk': ['few'],
  'hr': ['few'],
  'ro': ['few'],
  'ar': ['zero', 'two', 'few', 'many'],
  'he': ['two'],
};

final _hangul = RegExp(r'[가-힣]');
final _plural = RegExp(r'^\{\w+, plural,');

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

Map<String, String> _messages(Map<String, dynamic> arb) => {
  for (final e in arb.entries)
    if (!e.key.startsWith('@')) e.key: e.value as String,
};

/// `{name}` 과 ICU `{name, plural, …}` 의 변수 이름.
/// `=1{…}`, `one{…}` 같은 분기는 제외한다 (범주와 `{` 사이에 공백 금지).
Set<String> _placeholders(String v) => RegExp(
  r'(?<![\w=])\{(\w+)\s*[,}]',
).allMatches(v).map((m) => m.group(1)!).toSet();

/// 플레이스홀더만 있어 번역할 글자가 없는 값(예: `{date}`).
bool _placeholderOnly(String v) =>
    v.replaceAll(RegExp(r'\{\w+\}'), '').trim().isEmpty;

void main() {
  final arbs = {for (final l in _langs) l: _arb(l)};
  final msgs = {for (final l in _langs) l: _messages(arbs[l]!)};
  final template = msgs['ko']!;
  final en = msgs['en']!;

  /// 브랜드 키와 플레이스홀더만 있는 값을 뺀 번역 대상.
  Map<String, String> translatable(String l) => {
    for (final e in msgs[l]!.entries)
      if (!_brandKeys.contains(e.key) && !_placeholderOnly(e.value))
        e.key: e.value,
  };

  test('ARB 파일명이 @@locale 과 같다', () {
    expect(_langs, containsAll(['ko', 'en', 'zh', 'zh_Hant']));
    for (final l in _langs) {
      expect(arbs[l]!['@@locale'], l, reason: l);
    }
  });

  test('메시지 키 집합이 모두 같다', () {
    for (final l in _langs) {
      expect(msgs[l]!.keys.toSet(), template.keys.toSet(), reason: l);
    }
  });

  test('키별 플레이스홀더가 템플릿과 같다', () {
    for (final l in _langs) {
      for (final k in template.keys) {
        expect(
          _placeholders(msgs[l]![k]!),
          _placeholders(template[k]!),
          reason: '$l.$k',
        );
      }
    }
  });

  test('빈 값이 없다', () {
    for (final l in _langs) {
      for (final e in msgs[l]!.entries) {
        expect(e.value.trim(), isNotEmpty, reason: '$l.${e.key}');
      }
    }
  });

  test('핵심 키는 en 이 아닌 모든 언어에서 en 과 다르다', () {
    for (final l in _langs.where((l) => l != 'en')) {
      for (final k in _coreKeys) {
        expect(msgs[l]![k], isNot(en[k]), reason: '$l.$k');
      }
    }
  });

  test('ko 가 아닌 언어에 한글이 없다', () {
    for (final l in _langs.where((l) => l != 'ko')) {
      for (final e in translatable(l).entries) {
        expect(_hangul.hasMatch(e.value), isFalse, reason: '$l.${e.key}');
      }
    }
  });

  test('문자 체계: 값의 80% 이상이 해당 문자를 포함한다', () {
    for (final MapEntry(key: l, value: range) in _scripts.entries) {
      expect(_langs, contains(l));
      final re = RegExp('[$range]');
      final values = translatable(l).values;
      final hit = values.where(re.hasMatch).length;
      expect(hit / values.length, greaterThanOrEqualTo(0.8), reason: l);
    }
  });

  test('번체는 간체와 40% 이상 다르다', () {
    final hans = translatable('zh');
    final hant = translatable('zh_Hant');
    final diff = hant.keys.where((k) => hant[k] != hans[k]).length;
    expect(diff / hant.length, greaterThanOrEqualTo(0.4));
  });

  test('브랜드: appBadge 는 JANG, footer 에 Sudoku JANG', () {
    for (final l in _langs) {
      expect(msgs[l]!['appBadge'], 'JANG', reason: l);
      expect(msgs[l]!['footer'], contains('Sudoku JANG'), reason: l);
    }
  });

  test('복수형 범주: other 와 언어별 필수 범주가 있다', () {
    final pluralKeys = template.keys.where(
      (k) => _plural.hasMatch(template[k]!),
    );
    expect(pluralKeys, isNotEmpty);
    for (final l in _langs) {
      for (final k in pluralKeys) {
        final v = msgs[l]![k]!;
        expect(_plural.hasMatch(v), isTrue, reason: '$l.$k');
        for (final c in ['other', ...?_pluralCategories[l]]) {
          expect(v, contains('$c{'), reason: '$l.$k $c');
        }
      }
    }
  });

  test('가격 숫자가 없다', () {
    final banned = RegExp(r'₩|\d+[.,]\d{2}|990|1,900');
    for (final l in _langs) {
      for (final e in arbs[l]!.entries) {
        expect(
          banned.hasMatch(jsonEncode(e.value)),
          isFalse,
          reason: '$l.${e.key}',
        );
      }
    }
  });
}
