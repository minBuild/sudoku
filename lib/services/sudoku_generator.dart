import 'dart:math';

import '../models/difficulty.dart';
import '../models/sudoku_puzzle.dart';

class SudokuGenerator {
  final Random _rand = Random();

  SudokuPuzzle generate(Difficulty difficulty) {
    final solution = _generateSolvedGrid();
    final puzzle = _copyGrid(solution);

    final removals = _removalCountByDifficulty(difficulty);

    _digHolesEnsuringUniqueSolution(puzzle, solution, removals);

    return SudokuPuzzle(initial: puzzle, solution: solution);
  }

  // -------------------- Difficulty --------------------

  int _removalCountByDifficulty(Difficulty d) {
    // 빈칸 수(대략). 취향에 따라 조정 가능.
    switch (d) {
      case Difficulty.easy:
        return 38;
      case Difficulty.normal:
        return 45;
      case Difficulty.hard:
        return 52;
      case Difficulty.expert:
        return 58;
      case Difficulty.hell:
        return 62;
    }
  }

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
      ) {
    // 랜덤 셀 순서
    final positions = List<int>.generate(81, (i) => i)..shuffle(_rand);

    int removed = 0;
    for (final pos in positions) {
      if (removed >= removals) break;

      final r = pos ~/ 9;
      final c = pos % 9;

      if (puzzle[r][c] == 0) continue;

      final backup = puzzle[r][c];
      puzzle[r][c] = 0;

      // 유일해답 체크: 해답이 1개인지(2개 이상이면 복구)
      final count = _countSolutions(_copyGrid(puzzle), limit: 2);
      if (count != 1) {
        puzzle[r][c] = backup;
      } else {
        removed++;
      }
    }

    // 유일해답 조건 때문에 원하는 removals까지 못 뚫을 수 있음.
    // 그 경우 현재 상태로 반환(그래도 매번 다른 퍼즐은 됨).
  }

  int _countSolutions(List<List<int>> grid, {required int limit}) {
    int count = 0;

    void dfs() {
      if (count >= limit) return;

      final empty = _findEmpty(grid);
      if (empty == null) {
        count++;
        return;
      }

      final r = empty[0], c = empty[1];

      // 후보를 랜덤하게(퍼즐 다양성)
      final candidates = List<int>.generate(9, (i) => i + 1)..shuffle(_rand);

      for (final n in candidates) {
        if (_isValid(grid, r, c, n)) {
          grid[r][c] = n;
          dfs();
          grid[r][c] = 0;
          if (count >= limit) return;
        }
      }
    }

    dfs();
    return count;
  }

  List<List<int>> _copyGrid(List<List<int>> src) =>
      List.generate(9, (r) => List<int>.from(src[r]));
}
