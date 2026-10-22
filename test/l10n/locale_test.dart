import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/l10n/difficulty_label.dart';
import 'package:sudoku/l10n/l10n.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/widgets/number_pad.dart';

import '../fakes.dart';

const _codes = ['en', 'ko', 'fr', 'es', 'ja', 'pt'];

AppLocalizations _l(String code) => lookupAppLocalizations(Locale(code));

/// 기기 선호 언어를 [locales] 로 두고 앱을 띄운다 (실제 해석 경로).
Future<void> _pumpApp(WidgetTester tester, List<Locale> locales) async {
  tester.platformDispatcher.localesTestValue = locales;
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs)));
  await tester.pump();
}

void main() {
  group('기기 언어', () {
    for (final code in _codes) {
      testWidgets('$code 홈 화면', (tester) async {
        await _pumpApp(tester, [Locale(code)]);
        expect(find.text(_l(code).newGame), findsOneWidget);
      });
    }

    test('newGame 문구는 6개 언어가 서로 다르다', () {
      expect({for (final c in _codes) _l(c).newGame}.length, _codes.length);
    });

    test('지원 목록: en 이 첫 항목, 6개 언어', () {
      expect(AppLocalizations.supportedLocales.first, const Locale('en'));
      expect(
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
        _codes.toSet(),
      );
    });
  });

  group('폴백', () {
    final cases = <String, (List<Locale>, String)>{
      'de → en': ([const Locale('de')], 'en'),
      'zh-Hant → en': (
        [const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')],
        'en',
      ),
      'fr-CA → fr': ([const Locale('fr', 'CA')], 'fr'),
      'pt-BR → pt': ([const Locale('pt', 'BR')], 'pt'),
      '[zh, ja] → ja': ([const Locale('zh'), const Locale('ja')], 'ja'),
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
    await _pumpApp(tester, [const Locale('en')]);
    final en = _l('en');
    await tester.tap(find.text(en.newGame));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Difficulty.easy.label(en)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    SudokuController controller() => Provider.of<SudokuController>(
      tester.element(find.byType(NumberPad)),
      listen: false,
    );
    controller()
      ..select(0)
      ..input(solAt(0))
      ..select(1)
      ..input(wrongAt(1));
    await tester.pump();
    expect(find.text(en.undo), findsOneWidget);
    expect(find.text(en.mistakes(1, 5)), findsOneWidget);

    tester.platformDispatcher.localesTestValue = [const Locale('ko')];
    await tester.pump();

    final ko = _l('ko');
    expect(find.text(ko.undo), findsOneWidget);
    expect(find.text(en.undo), findsNothing);
    expect(find.text(ko.mistakes(1, 5)), findsOneWidget);
    expect(controller().valueAt(0), solAt(0));
    expect(controller().wrongCount, 1);

    // 게임 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });

  group('표기', () {
    setUpAll(() => initializeDateFormatting());

    test('fr 진행률은 퍼센트 형식', () {
      final s = _l('fr').continueDetail(0.5, '01:00');
      expect(s, contains('50'));
      expect(s, contains('%'));
      expect(s, isNot(contains('5000')));
    });

    for (final code in _codes) {
      test('$code recordDate', () {
        final s = _l(code).recordDate(DateTime(2026, 3, 5));
        expect(s, isNotEmpty);
        expect(s, contains('5'));
      });
    }
  });

  for (final code in _codes) {
    test('$code 난이도 이름 5개가 서로 다르다', () {
      final l = _l(code);
      expect(
        {for (final d in Difficulty.values) d.label(l)}.length,
        Difficulty.values.length,
      );
    });
  }
}
