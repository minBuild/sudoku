import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/l10n/difficulty_label.dart';
import 'package:sudoku/l10n/l10n.dart';
import 'package:sudoku/l10n/locale_resolution.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/widgets/board/sudoku_board.dart';
import 'package:sudoku/widgets/number_pad.dart';

import '../fakes.dart';

const _en = Locale('en');
const _zh = Locale('zh');
// Locale('zh_Hant') 는 languageCode 가 'zh_Hant' 인 다른 로케일이 된다.
const _zhHant = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');

final _supported = AppLocalizations.supportedLocales;

AppLocalizations _l(Locale locale) => lookupAppLocalizations(locale);

/// 기기 선호 언어를 [locales] 로 두고 앱을 띄운다 (실제 해석 경로).
Future<void> _pumpApp(WidgetTester tester, List<Locale> locales) async {
  tester.platformDispatcher.localesTestValue = locales;
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs)));
  await tester.pump();
}

Future<void> _enterGame(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(find.text(l.newGame));
  await tester.pumpAndSettle();
  await tester.tap(find.text(Difficulty.easy.label(l)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

SudokuController _controller(WidgetTester tester) =>
    Provider.of<SudokuController>(
      tester.element(find.byType(NumberPad)),
      listen: false,
    );

void main() {
  group('기기 언어', () {
    for (final locale in _supported) {
      testWidgets('${locale.toLanguageTag()} 홈 화면', (tester) async {
        await _pumpApp(tester, [locale]);
        expect(find.text(_l(locale).newGame), findsOneWidget);
      });
    }

    test('en 이 아닌 모든 언어의 newGame 이 en 과 다르다', () {
      final en = _l(_en).newGame;
      for (final locale in _supported.where((l) => l != _en)) {
        expect(_l(locale).newGame, isNot(en), reason: locale.toLanguageTag());
      }
    });

    test('지원 목록: en 이 첫 항목, ARB 수와 같고 간체가 번체보다 앞', () {
      final arbCount = Directory('lib/l10n')
          .listSync()
          .where((f) => RegExp(r'app_\w+\.arb$').hasMatch(f.path))
          .length;
      expect(_supported.first, _en);
      expect(_supported.length, arbCount);
      expect(_supported.toSet().length, arbCount);
      expect(_supported.indexOf(_zh), isNot(-1));
      expect(_supported.indexOf(_zh), lessThan(_supported.indexOf(_zhHant)));
    });
  });

  group('resolveAppLocale', () {
    const cases = <String, (List<Locale>?, Locale)>{
      'zh-Hans-CN': (
        [
          Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN',
          ),
        ],
        _zh,
      ),
      'zh-CN': ([Locale('zh', 'CN')], _zh),
      'zh-SG': ([Locale('zh', 'SG')], _zh),
      'zh-Hant-HK': (
        [
          Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK',
          ),
        ],
        _zhHant,
      ),
      'zh-TW': ([Locale('zh', 'TW')], _zhHant),
      'zh-HK': ([Locale('zh', 'HK')], _zhHant),
      'zh-MO': ([Locale('zh', 'MO')], _zhHant),
      'no-NO': ([Locale('no', 'NO')], Locale('nb')),
      'pt-PT': ([Locale('pt', 'PT')], Locale('pt')),
      'pt-BR': ([Locale('pt', 'BR')], Locale('pt')),
      'es-419': ([Locale('es', '419')], Locale('es')),
      'fr-CA': ([Locale('fr', 'CA')], Locale('fr')),
      'sw': ([Locale('sw')], _en),
      'nn': ([Locale('nn')], _en),
      '[sw, de]': ([Locale('sw'), Locale('de')], Locale('de')),
      '[sw, ja]': ([Locale('sw'), Locale('ja')], Locale('ja')),
      '[]': ([], _en),
      'null': (null, _en),
    };
    for (final MapEntry(key: name, value: (locales, expected))
        in cases.entries) {
      test('$name → ${expected.toLanguageTag()}', () {
        expect(resolveAppLocale(locales, _supported), expected);
      });
    }
  });

  group('폴백 (앱 경로)', () {
    final cases = <String, (List<Locale>, Locale)>{
      'sw → en': ([const Locale('sw')], _en),
      'zh-TW → zh-Hant': ([const Locale('zh', 'TW')], _zhHant),
      'no-NO → nb': ([const Locale('no', 'NO')], const Locale('nb')),
      '[sw, de] → de': (
        [const Locale('sw'), const Locale('de')],
        const Locale('de'),
      ),
      'fr-CA → fr': ([const Locale('fr', 'CA')], const Locale('fr')),
    };
    for (final MapEntry(key: name, value: (locales, expected))
        in cases.entries) {
      testWidgets(name, (tester) async {
        await _pumpApp(tester, locales);
        expect(find.text(_l(expected).newGame), findsOneWidget);
      });
    }
  });

  testWidgets('게임 중 언어를 바꿔도 보드와 실수가 유지된다', (tester) async {
    await _pumpApp(tester, [_en]);
    final en = _l(_en);
    await _enterGame(tester, en);

    _controller(tester)
      ..select(0)
      ..input(solAt(0))
      ..select(1)
      ..input(wrongAt(1));
    await tester.pump();
    expect(find.text(en.undo), findsOneWidget);
    expect(find.text(en.mistakes(1, 5)), findsOneWidget);

    tester.platformDispatcher.localesTestValue = [const Locale('ko')];
    await tester.pump();

    final ko = _l(const Locale('ko'));
    expect(find.text(ko.undo), findsOneWidget);
    expect(find.text(en.undo), findsNothing);
    expect(find.text(ko.mistakes(1, 5)), findsOneWidget);
    expect(_controller(tester).valueAt(0), solAt(0));
    expect(_controller(tester).wrongCount, 1);

    // 게임 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ar: 숫자패드는 1~9 왼쪽→오른쪽, 보드 (0,0) 탭은 index 0', (tester) async {
    const ar = Locale('ar');
    await _pumpApp(tester, [ar]);
    final l = _l(ar);
    await _enterGame(tester, l);
    expect(find.text(l.undo), findsOneWidget);

    final keys = find.descendant(
      of: find.byType(NumberPad),
      matching: find.byType(InkWell),
    );
    expect(
      tester.getCenter(keys.first).dx,
      lessThan(tester.getCenter(keys.last).dx),
    );
    // 첫 Text 가 숫자, 그 아래가 남은 개수.
    final firstLabel = tester.widget<Text>(
      find.descendant(of: keys.first, matching: find.byType(Text)).first,
    );
    expect(firstLabel.data, '1');

    _controller(tester).select(80);
    await tester.tapAt(
      tester.getTopLeft(find.byType(SudokuBoard)) + const Offset(4, 4),
    );
    await tester.pump();
    expect(_controller(tester).selected, 0);

    // 게임 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });

  group('표기', () {
    setUpAll(() => initializeDateFormatting());

    test('fr 진행률은 퍼센트 형식', () {
      final s = _l(const Locale('fr')).continueDetail(0.5, '01:00');
      expect(s, contains('50'));
      expect(s, contains('%'));
      expect(s, isNot(contains('5000')));
    });

    for (final locale in _supported) {
      test('${locale.toLanguageTag()} recordDate', () {
        final s = _l(locale).recordDate(DateTime(2026, 3, 5));
        expect(s, isNotEmpty);
        expect(s, contains(RegExp('[5٥]')));
      });
    }
  });

  for (final locale in _supported) {
    test('${locale.toLanguageTag()} 난이도 이름 5개가 서로 다르다', () {
      final l = _l(locale);
      expect(
        {for (final d in Difficulty.values) d.label(l)}.length,
        Difficulty.values.length,
      );
    });
  }
}
