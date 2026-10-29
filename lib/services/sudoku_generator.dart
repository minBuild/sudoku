import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/difficulty.dart';
import '../models/sudoku_puzzle.dart';

// 골든 테스트가 깨지면 올린다. 노드 상한·targetHoles·_rand 소비 순서 변경도 해당.
const kGeneratorVersion = 1;

/// 유일해 검사 1회의 방문 노드 상한. 넘으면 "유일하지 않음"으로 보고 칸을 되돌린다.
/// 시간이 아니라 노드 수라 모든 기기에서 같은 퍼즐이 나온다.
const kUniqueCheckNodeCap = 20000;

/// 생성 요청. enum·int·String 만 담아 isolate 로 넘길 수 있다.
class PuzzleRequest {
  const PuzzleRequest(this.difficulty, {this.seed, this.weekKey})
    : assert((seed == null) == (weekKey == null));

  final Difficulty difficulty;
  final int? seed;

  /// 캐시 키·정리용. 생성 결과에는 영향 없음.
  final String? weekKey;
}

/// `compute` 로 넘기기 위한 최상위 함수 (인스턴스 메서드는 isolate 로 못 넘김).
SudokuPuzzle generatePuzzle(Difficulty d) => SudokuGenerator().generate(d);

/// 시드가 있으면 시간 예산 없이 결정적으로 만든다.
SudokuPuzzle generateFor(PuzzleRequest r) => r.seed == null
    ? SudokuGenerator().generate(r.difficulty)
    : SudokuGenerator(
        rand: Random(r.seed),
      ).generate(r.difficulty, budget: null);

class SudokuGenerator {
  SudokuGenerator({Random? rand}) : _rand = rand ?? Random();

  static const defaultBudget = Duration(milliseconds: 1500);

  final Random _rand;

  /// [budget] 이 null 이면 시간 예산 없이 끝까지 뚫는다 (시드 생성용).
  SudokuPuzzle generate(
    Difficulty difficulty, {
    Duration? budget = defaultBudget,
  }) {
    final solution = _generateSolvedGrid();
    final puzzle = _copyGrid(solution);

    _digHolesEnsuringUniqueSolution(
      puzzle,
      solution,
      difficulty.targetHoles,
      budget,
    );

    return SudokuPuzzle(initial: puzzle, solution: solution);
  }

  /// 테스트에서 유일해를 확정하는 용도. 기본은 노드 상한 없음.
  @visibleForTesting
  int countSolutions(List<List<int>> g, {int limit = 2, int? nodeCap}) =>
      _countSolutions(g, limit: limit, nodeCap: nodeCap);

  // -------------------- Generate solved grid --------------------

  List<List<int>> _generateSolvedGrid() {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _fillDiagonalBoxes(grid);
    _solveBacktracking(grid);
    return grid;
  }

  void _fillDiagonalBoxes(List<List<int>> grid) {
    for (int i = 0; i < 9; i += 3) {
      _fillBox(grid, i, i);
    }
  }

  void _fillBox(List<List<int>> grid, int row, int col) {
    final nums = List<int>.generate(9, (i) => i + 1)..shuffle(_rand);
    int idx = 0;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        grid[row + r][col + c] = nums[idx++];
      }
    }
  }

  bool _solveBacktracking(List<List<int>> grid) {
    final empty = _findEmpty(grid);
    if (empty == null) return true;

    final r = empty[0], c = empty[1];
    final candidates = List<int>.generate(9, (i) => i + 1)..shuffle(_rand);

    for (final n in candidates) {
      if (_isValid(grid, r, c, n)) {
        grid[r][c] = n;
        if (_solveBacktracking(grid)) return true;
        grid[r][c] = 0;
      }
    }
    return false;
  }

  List<int>? _findEmpty(List<List<int>> grid) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == 0) return [r, c];
      }
    }
    return null;
  }

  bool _isValid(List<List<int>> grid, int row, int col, int n) {
    // row/col
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == n) return false;
      if (grid[i][col] == n) return false;
    }
    // box
    final br = (row ~/ 3) * 3;
    final bc = (col ~/ 3) * 3;
    for (int r = br; r < br + 3; r++) {
      for (int c = bc; c < bc + 3; c++) {
        if (grid[r][c] == n) return false;
      }
    }
    return true;
  }

  // -------------------- Dig holes with uniqueness check --------------------

  void _digHolesEnsuringUniqueSolution(
    List<List<int>> puzzle,
    List<List<int>> solution,
    int removals,
    Duration? budget,
  ) {
    // 랜덤 셀 순서
    final positions = List<int>.generate(81, (i) => i)..shuffle(_rand);
    final sw = Stopwatch()..start();

    int removed = 0;
    for (final pos in positions) {
      // 이미 뚫은 구멍은 각각 유일해 검증을 통과했으므로 여기서 끊어도 유효한 퍼즐이다.
      if (budget != null && sw.elapsed > budget) break;
      if (removed >= removals) break;

      final r = pos ~/ 9;
      final c = pos % 9;

      if (puzzle[r][c] == 0) continue;

      final backup = puzzle[r][c];
      puzzle[r][c] = 0;

      // 유일해답 체크: 해답이 1개인지(2개 이상이면 복구)
      final count = _countSolutions(
        puzzle,
        limit: 2,
        nodeCap: kUniqueCheckNodeCap,
      );
      if (count != 1) {
        puzzle[r][c] = backup;
      } else {
        removed++;
      }
    }

    // 유일해답 조건 때문에 원하는 removals까지 못 뚫을 수 있음.
    // 그 경우 현재 상태로 반환(그래도 매번 다른 퍼즐은 됨).
  }

  /// 비트마스크 + MRV(후보가 가장 적은 칸 우선) 해 개수 세기. [grid] 는 바꾸지 않는다.
  /// 해의 개수는 탐색 순서와 무관하다. 방문 노드가 [nodeCap] 을 넘으면 [limit] 을 반환한다.
  int _countSolutions(
    List<List<int>> grid, {
    required int limit,
    int? nodeCap,
  }) {
    final rows = List<int>.filled(9, 0);
    final cols = List<int>.filled(9, 0);
    final boxes = List<int>.filled(9, 0);
    final empties = <int>[];
    for (var i = 0; i < 81; i++) {
      final v = grid[i ~/ 9][i % 9];
      if (v == 0) {
        empties.add(i);
        continue;
      }
      final bit = 1 << (v - 1);
      final r = i ~/ 9, c = i % 9, b = r ~/ 3 * 3 + c ~/ 3;
      // 주어진 숫자끼리 충돌하면 해가 없다.
      if ((rows[r] | cols[c] | boxes[b]) & bit != 0) return 0;
      rows[r] |= bit;
      cols[c] |= bit;
      boxes[b] |= bit;
    }

    var count = 0;
    var nodes = 0;
    var capped = false;

    void dfs(int left) {
      if (left == 0) {
        count++;
        return;
      }
      if (nodeCap != null && ++nodes > nodeCap) {
        capped = true;
        return;
      }
      // MRV: 남은 빈칸 중 후보가 가장 적은 칸.
      var best = -1, bestMask = 0, bestCount = 10;
      for (var k = 0; k < left; k++) {
        final i = empties[k];
        final r = i ~/ 9, c = i % 9;
        final mask = ~(rows[r] | cols[c] | boxes[r ~/ 3 * 3 + c ~/ 3]) & 0x1FF;
        final n = _bitCount(mask);
        if (n < bestCount) {
          best = k;
          bestMask = mask;
          bestCount = n;
          if (n <= 1) break;
        }
      }
      if (bestCount == 0) return;

      final i = empties[best];
      empties[best] = empties[left - 1];
      empties[left - 1] = i;
      final r = i ~/ 9, c = i % 9, b = r ~/ 3 * 3 + c ~/ 3;
      var m = bestMask;
      while (m != 0) {
        final bit = m & -m;
        m ^= bit;
        rows[r] |= bit;
        cols[c] |= bit;
        boxes[b] |= bit;
        dfs(left - 1);
        rows[r] ^= bit;
        cols[c] ^= bit;
        boxes[b] ^= bit;
        if (count >= limit || capped) break;
      }
      empties[left - 1] = empties[best];
      empties[best] = i;
    }

    dfs(empties.length);
    return capped ? limit : count;
  }

  static int _bitCount(int m) {
    var n = 0;
    while (m != 0) {
      m &= m - 1;
      n++;
    }
    return n;
  }

  List<List<int>> _copyGrid(List<List<int>> src) =>
      List.generate(9, (r) => List<int>.from(src[r]));
}
