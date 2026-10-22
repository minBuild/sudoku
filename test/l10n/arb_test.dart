import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// ARB 정합성. 순수 Dart 로 파일을 읽어 대조한다.
const _langs = ['ko', 'en', 'fr', 'es', 'ja', 'pt'];

/// en 과 같은 값이어도 되는 키(실제 철자가 같은 단어).
const _sameAsEn = {
  'fr': {'appBadge', 'appTitle', 'footer', 'memo', 'difficultyExpert'},
  'es': {'appBadge', 'appTitle', 'footer', 'difficultyNormal'},
  'pt': {'appBadge', 'appTitle', 'footer', 'difficultyNormal'},
  'ja': {'appBadge'},
};

/// ko 와 같은 값이어도 되는 키.
const _sameAsKo = {'appBadge'};

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

Map<String, String> _messages(Map<String, dynamic> arb) => {
  for (final e in arb.entries)
    if (!e.key.startsWith('@')) e.key: e.value as String,
};

/// `{name}` 과 ICU `{name, plural, …}` 의 변수 이름.
Set<String> _placeholders(String v) =>
    RegExp(r'\{(\w+)\s*[,}]').allMatches(v).map((m) => m.group(1)!).toSet();

/// 플레이스홀더만 있어 번역할 글자가 없는 값(예: `{date}`).
bool _placeholderOnly(String v) =>
    v.replaceAll(RegExp(r'\{\w+\}'), '').trim().isEmpty;

void main() {
  final arbs = {for (final l in _langs) l: _arb(l)};
  final msgs = {for (final l in _langs) l: _messages(arbs[l]!)};
  final template = msgs['ko']!;

  test('ARB 6개가 있고 @@locale 이 파일명과 같다', () {
    final files = Directory('lib/l10n')
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last)
        .where((n) => n.endsWith('.arb'))
        .toSet();
    expect(files, {for (final l in _langs) 'app_$l.arb'});
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

  test('복붙 방지: ko·en 값을 그대로 쓰지 않는다', () {
    final en = msgs['en']!;
    for (final l in _langs.where((l) => l != 'ko')) {
      for (final e in msgs[l]!.entries) {
        if (_placeholderOnly(e.value)) continue;
        if (!_sameAsKo.contains(e.key)) {
          expect(e.value, isNot(template[e.key]), reason: '$l.${e.key} = ko');
        }
        if (l != 'en' && !_sameAsEn[l]!.contains(e.key)) {
          expect(e.value, isNot(en[e.key]), reason: '$l.${e.key} = en');
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
