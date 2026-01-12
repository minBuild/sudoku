import 'package:flutter/foundation.dart';
import '../models/sudoku_cell.dart';
import '../models/sudoku_puzzle.dart';
import 'dart:async';

class SudokuController extends ChangeNotifier {
  late SudokuPuzzle _puzzle;
  late List<List<SudokuCell>> _board; // 9x9 셀 상태

  final _errorController = StreamController<void>.broadcast();
  Stream<void> get errorStream => _errorController.stream;

  int? _selectedRow;
  int? _selectedCol;

  List<List<SudokuCell>> get board => _board;
  int? get selectedRow => _selectedRow;
  int? get selectedCol => _selectedCol;

  bool _isNoteMode = false;
  bool get isNoteMode => _isNoteMode;

  void toggleNoteMode() {
    _isNoteMode = !_isNoteMode;
    notifyListeners();
  }

  bool _instantCheck = true;
  bool get instantCheck => _instantCheck;

  void toggleInstantCheck() {
    _instantCheck = !_instantCheck;
    _updateWrongMarks();
    notifyListeners();
  }

  SudokuController() {
    _loadSamplePuzzle();
  }

  void _loadSamplePuzzle() {
    // 간단한 예제 퍼즐 (0 = 빈칸)
    const initial = [
      [0, 0, 0, 2, 6, 0, 7, 0, 1],
      [6, 8, 0, 0, 7, 0, 0, 9, 0],
      [1, 9, 0, 0, 0, 4, 5, 0, 0],
      [8, 2, 0, 1, 0, 0, 0, 4, 0],
      [0, 0, 4, 6, 0, 2, 9, 0, 0],
      [0, 5, 0, 0, 0, 3, 0, 2, 8],
      [0, 0, 9, 3, 0, 0, 0, 7, 4],
      [0, 4, 0, 0, 5, 0, 0, 3, 6],
      [7, 0, 3, 0, 1, 8, 0, 0, 0],
    ];

    const solution = [
      [4, 3, 5, 2, 6, 9, 7, 8, 1],
      [6, 8, 2, 5, 7, 1, 4, 9, 3],
      [1, 9, 7, 8, 3, 4, 5, 6, 2],
      [8, 2, 6, 1, 9, 5, 3, 4, 7],
      [3, 7, 4, 6, 8, 2, 9, 1, 5],
      [9, 5, 1, 7, 4, 3, 6, 2, 8],
      [5, 1, 9, 3, 2, 6, 8, 7, 4],
      [2, 4, 8, 9, 5, 7, 1, 3, 6],
      [7, 6, 3, 4, 1, 8, 2, 5, 9],
    ];

    _puzzle = SudokuPuzzle(initial: initial, solution: solution);

    _board = List.generate(9, (row) {
      return List.generate(9, (col) {
        final v = initial[row][col];
        return SudokuCell(
          row: row,
          col: col,
          isGiven: v != 0,
          value: v == 0 ? null : v,
        );
      });
    });

    _selectedRow = null;
    _selectedCol = null;
    _isNoteMode = false;

    _updateConflicts();
    _updateHighlights();
    notifyListeners();
  }

  void selectCell(int row, int col) {
    if (_board[row][col].isGiven) {
      // 고정 숫자 클릭도 허용 (선택 + 하이라이트만)
    }

    // 기존 선택 해제
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        _board[r][c].isSelected = false;
      }
    }

    _board[row][col].isSelected = true;
    _selectedRow = row;
    _selectedCol = col;

    _updateHighlights(); // ← 선택한 숫자 기준으로 하이라이트
    notifyListeners();
  }

  void inputNumber(int number) {
    if (_selectedRow == null || _selectedCol == null) return;

    final cell = _board[_selectedRow!][_selectedCol!];
    if (cell.isGiven) return;

    // ✅ 메모 모드: 값이 있으면 날리고, notes 토글
    if (_isNoteMode) {
      // 값이 있던 칸이면 값을 지우고 메모로 전환
      if (cell.value != null) {
        cell.value = null;
        cell.isConflicted = false; // 값 지웠으니 일단 이 칸 충돌 플래그 초기화
      }

      if (cell.notes.contains(number)) {
        cell.notes.remove(number);
      } else {
        cell.notes.add(number);
      }

      // 값이 바뀐건 아니지만, 값 지운 경우 충돌 상태/하이라이트 정리 필요
      _updateConflicts();
      _updateHighlights();
      notifyListeners();
      return;
    }

    // ✅ 입력 모드: 값 입력 + 메모 초기화
    cell.value = number;
    cell.notes.clear();

    // ✅ 정답 즉시 체크
    if (_instantCheck) {
      cell.isWrong = (_puzzle.solution[cell.row][cell.col] != number);
    } else {
      cell.isWrong = false;
    }

    final bool wasConflictedBefore = cell.isConflicted;

    _updateConflicts();
    _updateHighlights();

    if (!wasConflictedBefore && cell.isConflicted) {
      _errorController.add(null); // 보드 흔들기 트리거
    }

    notifyListeners();
  }

  void clearSelectedCell() {
    if (_selectedRow == null || _selectedCol == null) return;
    final cell = _board[_selectedRow!][_selectedCol!];
    if (cell.isGiven) return;

    cell.value = null;
    cell.notes.clear();
    cell.isWrong = false;

    _updateConflicts();
    _updateHighlights();
    notifyListeners();
  }


  void _updateConflicts() {
    // 모든 셀의 conflict 초기화
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        _board[r][c].isConflicted = false;
      }
    }

    // 행 검사
    for (var r = 0; r < 9; r++) {
      final map = <int, List<SudokuCell>>{};
      for (var c = 0; c < 9; c++) {
        final v = _board[r][c].value;
        if (v == null) continue;
        map.putIfAbsent(v, () => []).add(_board[r][c]);
      }
      for (final entry in map.entries) {
        if (entry.value.length > 1) {
          for (final cell in entry.value) {
            cell.isConflicted = true;
          }
        }
      }
    }

    // 열 검사
    for (var c = 0; c < 9; c++) {
      final map = <int, List<SudokuCell>>{};
      for (var r = 0; r < 9; r++) {
        final v = _board[r][c].value;
        if (v == null) continue;
        map.putIfAbsent(v, () => []).add(_board[r][c]);
      }
      for (final entry in map.entries) {
        if (entry.value.length > 1) {
          for (final cell in entry.value) {
            cell.isConflicted = true;
          }
        }
      }
    }

    // 3x3 박스 검사
    for (var br = 0; br < 3; br++) {
      for (var bc = 0; bc < 3; bc++) {
        final map = <int, List<SudokuCell>>{};
        for (var r = br * 3; r < br * 3 + 3; r++) {
          for (var c = bc * 3; c < bc * 3 + 3; c++) {
            final v = _board[r][c].value;
            if (v == null) continue;
            map.putIfAbsent(v, () => []).add(_board[r][c]);
          }
        }
        for (final entry in map.entries) {
          if (entry.value.length > 1) {
            for (final cell in entry.value) {
              cell.isConflicted = true;
            }
          }
        }
      }
    }
  }

  void _updateHighlights() {
    // 선택된 칸이 없으면 전체 하이라이트 해제
    if (_selectedRow == null || _selectedCol == null) {
      for (var r = 0; r < 9; r++) {
        for (var c = 0; c < 9; c++) {
          _board[r][c].isHighlighted = false;
        }
      }
      return;
    }

    final sr = _selectedRow!;
    final sc = _selectedCol!;
    final selectedCell = _board[sr][sc];
    final selectedValue = selectedCell.value;

    // 🔴 선택한 칸이 "빈 칸"이면 → 아무 하이라이트도 안 보이게
    if (selectedValue == null) {
      for (var r = 0; r < 9; r++) {
        for (var c = 0; c < 9; c++) {
          _board[r][c].isHighlighted = false;
        }
      }
      return;
    }

    // 여기부터는 "숫자가 있는 칸"을 클릭했을 때 동작
    // 선택된 칸이 속한 3x3 박스 시작 인덱스 계산
    final boxStartRow = (sr ~/ 3) * 3;
    final boxStartCol = (sc ~/ 3) * 3;

    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cell = _board[r][c];

        final sameRow = r == sr;
        final sameCol = c == sc;
        final sameBox = (r >= boxStartRow &&
            r < boxStartRow + 3 &&
            c >= boxStartCol &&
            c < boxStartCol + 3);

        final sameValue = cell.value == selectedValue;

        // ✅ 규칙:
        // 1) 선택한 칸 기준 가로/세로/3x3 박스는 노란색
        // 2) 값이 같은 모든 칸(예: 1)도 노란색
        if (sameRow || sameCol || sameBox || sameValue) {
          cell.isHighlighted = true;
        } else {
          cell.isHighlighted = false;
        }
      }
    }
  }

  void _updateWrongMarks() {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cell = _board[r][c];
        if (cell.value == null || !_instantCheck) {
          cell.isWrong = false;
        } else {
          cell.isWrong = (_puzzle.solution[r][c] != cell.value);
        }
      }
    }
  }

  bool get isSolved {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (_board[r][c].value == null || _board[r][c].isConflicted) {
          return false;
        }
      }
    }
    return true;
  }

  void reset() {
    _loadSamplePuzzle();
  }
}
