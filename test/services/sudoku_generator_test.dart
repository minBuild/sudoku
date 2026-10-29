// 측정한 평균 빈칸 수를 출력한다.
// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'dart:math';

import 'package:sudoku/services/sudoku_generator.dart';
import 'package:sudoku/services/weekly/iso_week.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';

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

  // 새 그룹 전체에 90초 타임아웃 (flutter_test 의 group 은 timeout 인자가 없다).
  group('시드 생성', () {
    void t(String name, dynamic Function() body) =>
        test(name, body, timeout: const Timeout(Duration(seconds: 90)));

    String flat(List<List<int>> g) => [for (final r in g) ...r].join();

    t('같은 시드는 같은 퍼즐, 다른 시드는 다른 퍼즐', () {
      for (final d in Difficulty.values) {
        final a = generateFor(PuzzleRequest(d, seed: 42, weekKey: 'x'));
        final b = generateFor(PuzzleRequest(d, seed: 42, weekKey: 'x'));
        final c = generateFor(PuzzleRequest(d, seed: 43, weekKey: 'x'));
        expect(flat(a.initial), flat(b.initial), reason: d.name);
        expect(flat(a.solution), flat(b.solution), reason: d.name);
        expect(flat(a.initial), isNot(flat(c.initial)), reason: d.name);
      }
    });

    // 골든: 2026-W44 보드의 initial 81자. 깨지면 kGeneratorVersion 을 올린다.
    const golden = {
      Difficulty.easy:
          '090400000205300100041890567873650000010200056002180793908021604120003980600008230',
      Difficulty.normal:
          '001942078000103000309800010000701540745020000000600090024010609503206487000008005',
      Difficulty.hard:
          '082000090193500006645000700000020100907300002020600089006004001000000040500806000',
      Difficulty.expert:
          '000001070000060000921040800005080000340000000700306000009070160000008702003004080',
      Difficulty.hell:
          '000091000800000004004000629010004030000076050069050000070005090001003500000600700',
    };

    for (final d in Difficulty.values) {
      t('골든 ${d.name} (kGeneratorVersion=$kGeneratorVersion)', () {
        final p = generateFor(WeeklyBoard('2026-W44', d).request);
        expect(flat(p.initial), golden[d]);
        expectValid(gen, p); // countSolutions 는 상한 없이 센다.
        expect(holesOf(p), greaterThanOrEqualTo(d.minAcceptHoles));
      });
    }

    t('솔버 교체 동등성: 무작위 20판에서 단순 DFS 와 해 개수가 같다', () {
      final rand = Random(7);
      for (var k = 0; k < 20; k++) {
        final p = SudokuGenerator(
          rand: Random(k),
        ).generate(Difficulty.values[k % 5], budget: null);
        // 유일해 퍼즐에서 몇 칸을 더 비워 해가 여러 개인 경우도 섞는다.
        final g = [for (final r in p.initial) List<int>.from(r)];
        for (var extra = 0; extra < k % 4 * 2; extra++) {
          g[rand.nextInt(9)][rand.nextInt(9)] = 0;
        }
        expect(
          gen.countSolutions(g),
          _referenceCount(g, limit: 2),
          reason: 'case $k',
        );
      }
    });

    t('노드 상한: 빈 보드에 상한 100 이면 2', () {
      final empty = List.generate(9, (_) => List.filled(9, 0));
      expect(gen.countSolutions(empty, nodeCap: 100), 2);
    });

    t('실측: 난이도별 시드 5개 생성 ms (중앙값·최댓값) + 합격선', () {
      for (final d in Difficulty.values) {
        final times = <int>[];
        final holes = <int>[];
        for (var w = 40; w < 45; w++) {
          final sw = Stopwatch()..start();
          final p = generateFor(
            PuzzleRequest(
              d,
              seed: weeklySeed('2026-W$w', d),
              weekKey: '2026-W$w',
            ),
          );
          times.add(sw.elapsedMilliseconds);
          holes.add(holesOf(p));
        }
        times.sort();
        print(
          '시드 생성 ${d.name}: 중앙값 ${times[2]}ms, 최댓값 ${times.last}ms, '
          '빈칸 $holes',
        );
      }
      final sw = Stopwatch()..start();
      generateFor(WeeklyBoard('2026-W44', Difficulty.hell).request);
      expect(sw.elapsedMilliseconds, lessThan(3000));
    });
  });
}

/// 교체 전 단순 DFS 솔버(참조 구현). 솔버 동등성 확인용.
int _referenceCount(List<List<int>> src, {required int limit}) {
  final grid = [for (final r in src) List<int>.from(r)];
  var count = 0;

  bool isValid(int row, int col, int n) {
    for (var i = 0; i < 9; i++) {
      if (grid[row][i] == n || grid[i][col] == n) return false;
    }
    final br = row ~/ 3 * 3, bc = col ~/ 3 * 3;
    for (var r = br; r < br + 3; r++) {
      for (var c = bc; c < bc + 3; c++) {
        if (grid[r][c] == n) return false;
      }
    }
    return true;
  }

  void dfs() {
    if (count >= limit) return;
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (grid[r][c] != 0) continue;
        for (var n = 1; n <= 9; n++) {
          if (isValid(r, c, n)) {
            grid[r][c] = n;
            dfs();
            grid[r][c] = 0;
            if (count >= limit) return;
          }
        }
        return;
      }
    }
    count++;
  }

  dfs();
  return count;
}
