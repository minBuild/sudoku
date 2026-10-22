import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/l10n/difficulty_label.dart';
import 'package:sudoku/l10n/l10n.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_record.dart';
import 'package:sudoku/services/record_store.dart';

import '../fakes.dart';

/// 360×640dp 에서 6개 언어 × 화면별 overflow 를 확인한다.
const _codes = ['en', 'ko', 'fr', 'es', 'ja', 'pt'];

Future<AppLocalizations> _pumpApp(
  WidgetTester tester,
  String code, {
  double textScale = 1.0,
}) async {
  tester.view
    ..physicalSize = const Size(360, 640)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  tester.platformDispatcher
    ..localesTestValue = [Locale(code)]
    ..textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await RecordStore(prefs).add(
    GameRecord(
      difficulty: Difficulty.expert,
      elapsedSeconds: 754,
      wrongCount: 2,
      finishedAt: DateTime(2026, 9, 28),
      instantCheck: false,
    ),
  );
  await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs)));
  await tester.pumpAndSettle();
  return lookupAppLocalizations(Locale(code));
}

Future<void> _enterGame(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(find.text(l.newGame));
  await tester.pumpAndSettle();
  await tester.tap(find.text(Difficulty.easy.label(l)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  expect(find.text(l.undo), findsOneWidget);
}

void _expectNoOverflow(WidgetTester tester, String what) =>
    expect(tester.takeException(), isNull, reason: what);

void main() {
  for (final code in _codes) {
    group(code, () {
      testWidgets('홈', (tester) async {
        await _pumpApp(tester, code);
        _expectNoOverflow(tester, '$code 홈');
      });

      testWidgets('난이도 시트', (tester) async {
        final l = await _pumpApp(tester, code);
        await tester.tap(find.text(l.newGame));
        await tester.pumpAndSettle();
        expect(find.text(l.chooseDifficulty), findsOneWidget);
        _expectNoOverflow(tester, '$code 난이도 시트');
      });

      testWidgets('게임', (tester) async {
        final l = await _pumpApp(tester, code);
        await _enterGame(tester, l);
        _expectNoOverflow(tester, '$code 게임');
        await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리
      });

      testWidgets('설정', (tester) async {
        final l = await _pumpApp(tester, code);
        await tester.tap(find.text(l.settings));
        await tester.pumpAndSettle();
        expect(find.text(l.restorePurchases), findsOneWidget);
        _expectNoOverflow(tester, '$code 설정');
      });

      testWidgets('기록', (tester) async {
        final l = await _pumpApp(tester, code);
        await tester.tap(find.text(l.records));
        await tester.pumpAndSettle();
        expect(find.text(l.recentRecords(1)), findsOneWidget);
        _expectNoOverflow(tester, '$code 기록');
      });

      testWidgets('글자 1.3배: 홈', (tester) async {
        await _pumpApp(tester, code, textScale: 1.3);
        _expectNoOverflow(tester, '$code 홈 1.3배');
      });

      testWidgets('글자 1.3배: 게임', (tester) async {
        final l = await _pumpApp(tester, code, textScale: 1.3);
        await _enterGame(tester, l);
        _expectNoOverflow(tester, '$code 게임 1.3배');
        await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리
      });
    });
  }
}
