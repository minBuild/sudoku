import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/screens/game_screen.dart';
import 'package:sudoku/screens/home_screen.dart';
import 'package:sudoku/screens/prepare_screen.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';

import '../fakes.dart';

void main() {
  for (final weekly in [null, const WeeklyBoard('2026-W44', Difficulty.hell)]) {
    testWidgets('생성 중 닫기(X)로 나가고, 뒤늦게 끝나도 화면 전환·예외 없음 '
        '(${weekly == null ? '일반' : '주간'})', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final gen = Completer<SudokuPuzzle>();
      final ads = FakeAds();
      await tester.pumpWidget(
        SudokuApp(
          deps: fakeDeps(prefs, ads: ads, generate: (_) => gen.future),
        ),
      );
      await tester.pump();
      Navigator.of(tester.element(find.byType(HomeScreen))).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              PrepareScreen(difficulty: Difficulty.hell, weekly: weekly),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(PrepareScreen), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(PrepareScreen), findsNothing);
      expect(ads.cancelCalls, greaterThanOrEqualTo(1));

      gen.complete(puzzleWithHoles([0, 1]));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GameScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
