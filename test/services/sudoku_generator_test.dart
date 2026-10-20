// 측정한 평균 빈칸 수를 출력한다.
// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/services/sudoku_generator.dart';

bool validSolution(List<List<int>> g) {
  for (var k = 0; k < 9; k++) {
    final row = <int>{}, col = <int>{}, box = <int>{};
    for (var j = 0; j < 9; j++) {
      row.add(g[k][j]);
      col.add(g[j][k]);
      box.add(g[k ~/ 3 * 3 + j ~/ 3][k % 3 * 3 + j % 3]);
    }
    final all = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    if (!row.containsAll(all) ||
        !col.containsAll(all) ||
        !box.containsAll(all)) {
      return false;
    }
  }
  return true;
}

int holesOf(SudokuPuzzle p) =>
    p.initial.expand((r) => r).where((v) => v == 0).length;

void expectValid(SudokuGenerator gen, SudokuPuzzle p) {
  expect(validSolution(p.solution), isTrue);
  for (var r = 0; r < 9; r++) {
    for (var c = 0; c < 9; c++) {
      final v = p.initial[r][c];
      if (v != 0) expect(v, p.solution[r][c]);
    }
  }
  expect(gen.countSolutions(p.initial), 1);
}

void main() {
  final gen = SudokuGenerator();

  for (final d in Difficulty.values) {
    test('${d.name}: 3판 유효·유일해·빈칸 범위', () {
      var total = 0;
      for (var i = 0; i < 3; i++) {
        final p = gen.generate(d);
        expectValid(gen, p);
        final holes = holesOf(p);
        total += holes;
        expect(holes, greaterThanOrEqualTo(d.minAcceptHoles));
        expect(holes, lessThanOrEqualTo(d.targetHoles));
      }
      print('평균 빈칸 수 ${d.name}: ${(total / 3).toStringAsFixed(1)}');
    });
  }

  test('easy 는 10판 모두 빈칸 38개', () {
    for (var i = 0; i < 10; i++) {
      expect(holesOf(gen.generate(Difficulty.easy)), 38);
    }
  });

  test('budget 200ms 로 Hell 을 만들면 1초 안에 유일해 퍼즐', () {
    final sw = Stopwatch()..start();
    final p = gen.generate(
      Difficulty.hell,
      budget: const Duration(milliseconds: 200),
    );
    sw.stop();
    expect(sw.elapsed, lessThan(const Duration(seconds: 1)));
    expectValid(gen, p);
  });

  test('최상위 generatePuzzle', () {
    expectValid(gen, generatePuzzle(Difficulty.normal));
  });
}
