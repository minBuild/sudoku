import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/l10n/l10n.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/widgets/board/sudoku_board.dart';

import '../fakes.dart';

/// 보드 배경 + 테두리. 메모 매치 필은 이 위에 서브셀마다 1개씩 더해진다.
const _base = 2;

final _board = find.descendant(
  of: find.byType(SudokuBoard),
  matching: find.byType(CustomPaint),
);

Future<void> _pump(WidgetTester tester, SudokuController c) async {
  c.pause(); // 타이머 정리. 그리기는 상태와 무관하다.
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ChangeNotifierProvider<SudokuController>.value(
          value: c,
          child: const SizedBox(width: 330, child: SudokuBoard()),
        ),
      ),
    ),
  );
}

/// [holes] 를 비우고 [noted] 칸에 [n] 을 메모한 진행 중 판.
SudokuController _withNotes(List<int> holes, List<int> noted, int n) {
  final c = SudokuController.fresh(
    puzzleWithHoles(holes),
    Difficulty.easy,
    instantCheck: true,
  )..resume();
  c.toggleNote();
  for (final i in noted) {
    c
      ..select(i)
      ..input(n);
  }
  c.toggleNote();
  return c;
}

void main() {
  // 0행은 1..9 이므로 4번 칸(given)의 값은 5.
  const holes = [30, 40, 50, 60, 70];

  testWidgets('선택 값과 같은 메모 서브셀마다 필을 그린다', (tester) async {
    final c = _withNotes(holes, [30, 40, 60], 5);
    addTearDown(c.dispose);
    expect(c.isGiven(4), isTrue);
    expect(c.valueAt(4), 5);
    c.select(4);
    await _pump(tester, c);
    expect(_board, paintsExactlyCountTimes(#drawRRect, _base + 3));
  });

  testWidgets('빈 칸을 선택하면 필이 없다', (tester) async {
    final c = _withNotes(holes, [30, 40, 60], 5);
    addTearDown(c.dispose);
    c.select(50);
    await _pump(tester, c);
    expect(_board, paintsExactlyCountTimes(#drawRRect, _base));
  });

  testWidgets('다 풀어 선택이 없어지면 필이 없다', (tester) async {
    final c = _withNotes(holes, [30, 40, 60], 5);
    addTearDown(c.dispose);
    for (final i in holes) {
      c
        ..select(i)
        ..input(solAt(i));
    }
    expect(c.selected, isNull);
    await _pump(tester, c);
    expect(_board, paintsExactlyCountTimes(#drawRRect, _base));
  });

  testWidgets('선택 값을 메모한 칸이 없으면 필이 없다', (tester) async {
    final c = _withNotes(holes, [30, 40, 60], 5);
    addTearDown(c.dispose);
    // 0번 칸의 값은 1. 메모에는 5 만 있다.
    c.select(0);
    expect(c.valueAt(0), 1);
    await _pump(tester, c);
    expect(_board, paintsExactlyCountTimes(#drawRRect, _base));
  });
}
