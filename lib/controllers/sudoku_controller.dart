import 'package:flutter/foundation.dart';
import '../models/difficulty.dart';
import '../models/sudoku_cell.dart';
import '../models/sudoku_puzzle.dart';
import '../services/sudoku_generator.dart';
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

  final SudokuGenerator _generator = SudokuGenerator();

  Difficulty _difficulty = Difficulty.normal;
  Difficulty get difficulty => _difficulty;

  // "reset"은 현재 퍼즐로 다시 시작하도록 initial snapshot을 저장해둠
  late List<List<int>> _initialSnapshot;

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

  int _wrongCount = 0;
  int get wrongCount => _wrongCount;

  static const int maxWrongCount = 5;

  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;


  SudokuController() {
    newGame(Difficulty.normal);
  }

  void newGame(Difficulty difficulty) {
    _difficulty = difficulty;
    _puzzle = _generator.generate(difficulty);

    _board = List.generate(9, (row) {
      return List.generate(9, (col) {
        final v = _puzzle.initial[row][col];
        return SudokuCell(
          row: row,
          col: col,
          isGiven: v != 0,
          value: v == 0 ? null : v,
          // notes/isWrong/isHighlighted 등은 기본 false/empty
        );
      });
    });

    _initialSnapshot =
        List.generate(9, (r) => List<int>.from(_puzzle.initial[r]));

    _selectedRow = null;
    _selectedCol = null;

    _wrongCount = 0;
    _isGameOver = false;
    _isNoteMode = false;

    _updateConflicts();
    _updateHighlights();
    // _updateWrongMarks(); // instantCheck 토글을 쓰고 있으면 필요 시 호출
    notifyListeners();
  }

  void reset() {
    // 현재 퍼즐(_puzzle.solution)은 유지, initialSnapshot으로 다시 시작
    _board = List.generate(9, (row) {
      return List.generate(9, (col) {
        final v = _initialSnapshot[row][col];
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

    _wrongCount = 0;
    _isGameOver = false;
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
    if (_isGameOver) return;

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
    final int? prevValue = cell.value;
    final bool wasConflictedBefore = cell.isConflicted;

    // 같은 숫자를 또 누른 건 오답처리 안함
    if (prevValue == number) return;

    cell.value = number;
    cell.notes.clear();

    // ✅ 정답 즉시 체크
    if (_instantCheck) {
      cell.isWrong = (_puzzle.solution[cell.row][cell.col] != number);
    } else {
      cell.isWrong = false;
    }

    _updateConflicts();
    _updateHighlights();

    if (_instantCheck && cell.isWrong) {
      _wrongCount += 1;

      // 원하면 오답일 때만 흔들기
      _errorController.add(null);

      if (_wrongCount >= maxWrongCount) {
        _isGameOver = true;
      }

      notifyListeners();
      return;
    }

    if (!wasConflictedBefore && cell.isConflicted) {
      _errorController.add(null);
    }


    notifyListeners();
  }

  void clearSelectedCell() {
    if (_selectedRow == null || _selectedCol == null) return;
    if (_isGameOver) return;

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
}
