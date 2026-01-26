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
  int? _selectedNumber;
  int? get selectedNumber => _selectedNumber;

  void selectNumber(int number) {
    _selectedNumber = number;
    notifyListeners();
  }

  Timer? _timer;
  int _elapsedSeconds = 0;

  int get elapsedSeconds => _elapsedSeconds;

  String get elapsedLabel {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // 게임 끝났으면 증가 중단
      if (_isGameOver || isSolved) {
        _timer?.cancel();
        _timer = null;
        return;
      }
      _elapsedSeconds += 1;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resetTimer() {
    _elapsedSeconds = 0;
  }

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

  final List<_HistoryEntry> _history = [];
  static const int _maxHistory = 200; // 너무 커지는 것 방지(취향)

  SudokuController() {
    _initEmptyBoard();
  }

  void _initEmptyBoard() {
    _board = List.generate(9, (r) {
      return List.generate(9, (c) {
        return SudokuCell(row: r, col: c, isGiven: false, value: null);
      });
    });

    _selectedRow = null;
    _selectedCol = null;

    _wrongCount = 0;
    _isGameOver = false;
    _isNoteMode = false;

    _resetTimer();      // 시간도 0으로
    _stopTimer();       // 타이머 멈춤

    notifyListeners();
  }

  void newGame(Difficulty difficulty) {
    _history.clear();
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
    _selectedNumber = null;

    _updateConflicts();
    _updateHighlights();
    // _updateWrongMarks(); // instantCheck 토글을 쓰고 있으면 필요 시 호출
    _resetTimer();
    _startTimer();
    notifyListeners();
  }

  void reset() {
    _history.clear();
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
    _selectedNumber = null;

    _updateConflicts();
    _updateHighlights();
    _resetTimer();
    _startTimer();
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
    _selectedNumber = number;

    try {
      if (_selectedRow == null || _selectedCol == null) return;
      if (_isGameOver) return;

      final cell = _board[_selectedRow!][_selectedCol!];
      if (cell.isGiven) return;

      _pushHistoryForSelection(cell.row, cell.col);

      // ✅ 메모 모드: 값이 있으면 날리고, notes 토글
      if (_isNoteMode) {
        _pushHistoryForSelection(cell.row, cell.col);
        if (cell.value != null) {
          cell.value = null;
          cell.isConflicted = false;
        }

        if (cell.notes.contains(number)) {
          cell.notes.remove(number);
        } else {
          cell.notes.add(number);
        }

        _updateConflicts();
        _updateHighlights();
        return;
      }

      // ✅ 입력 모드
      final int? prevValue = cell.value;
      final bool wasConflictedBefore = cell.isConflicted;

      if (prevValue == number) return;

      _pushHistoryForSelection(cell.row, cell.col);

      cell.value = number;
      cell.notes.clear();

      if (_instantCheck) {
        cell.isWrong = (_puzzle.solution[cell.row][cell.col] != number);
      } else {
        cell.isWrong = false;
      }

      if (!_instantCheck || !cell.isWrong) {
        _clearNotesByConfirmedNumber(cell.row, cell.col, number);
      }

      _updateConflicts();
      _updateHighlights();

      if (_instantCheck && cell.isWrong) {
        _wrongCount += 1;
        _errorController.add(null);

        if (_wrongCount >= maxWrongCount) {
          _isGameOver = true;
        }
        return;
      }

      if (!wasConflictedBefore && cell.isConflicted) {
        _errorController.add(null);
      }
    } finally {
      // ✅ 어떤 경로로 return 하든 항상 선택 해제
      _selectedNumber = null;
      notifyListeners();
    }
  }

  void clearSelectedCell() {
    if (_selectedRow == null || _selectedCol == null) return;
    if (_isGameOver) return;

    final cell = _board[_selectedRow!][_selectedCol!];
    if (cell.isGiven) return;

    _pushHistoryForSelection(cell.row, cell.col);

    cell.value = null;
    cell.notes.clear();
    cell.isWrong = false;
    _selectedNumber = null;

    _updateConflicts();
    _updateHighlights();
    notifyListeners();
  }

  void _clearNotesByConfirmedNumber(int row, int col, int number) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (r == row && c == col) continue;

        final sameRow = r == row;
        final sameCol = c == col;
        final sameBox = (r ~/ 3 == row ~/ 3) && (c ~/ 3 == col ~/ 3);

        if (sameRow || sameCol || sameBox) {
          _board[r][c].notes.remove(number);
        }
      }
    }
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

  int countNumber(int number) {
    int count = 0;
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (_board[r][c].value == number) {
          count++;
        }
      }
    }
    return count;
  }

  bool isNumberCompleted(int number) {
    return countNumber(number) >= 9;
  }

  Set<String> _affectedKeys(int row, int col) {
    final keys = <String>{};

    // row
    for (int c = 0; c < 9; c++) {
      keys.add('$row,$c');
    }
    // col
    for (int r = 0; r < 9; r++) {
      keys.add('$r,$col');
    }
    // box
    final br = (row ~/ 3) * 3;
    final bc = (col ~/ 3) * 3;
    for (int r = br; r < br + 3; r++) {
      for (int c = bc; c < bc + 3; c++) {
        keys.add('$r,$c');
      }
    }

    return keys;
  }

  void _pushHistoryForSelection(int row, int col) {
    final keys = _affectedKeys(row, col);

    final snapshots = <_CellSnapshot>[];
    for (final k in keys) {
      final parts = k.split(',');
      final r = int.parse(parts[0]);
      final c = int.parse(parts[1]);
      final cell = _board[r][c];

      snapshots.add(_CellSnapshot(
        row: r,
        col: c,
        value: cell.value,
        notes: Set<int>.from(cell.notes),
        isWrong: cell.isWrong,
      ));
    }

    _history.add(_HistoryEntry(
      cells: snapshots,
      prevWrongCount: _wrongCount,
      prevIsGameOver: _isGameOver,
    ));

    if (_history.length > _maxHistory) {
      _history.removeAt(0);
    }
  }

  void rollback() {
    if (_history.isEmpty) return;

    final last = _history.removeLast();

    for (final snap in last.cells) {
      final cell = _board[snap.row][snap.col];
      if (cell.isGiven) continue; // 혹시 모르니 보호

      cell.value = snap.value;
      cell.notes
        ..clear()
        ..addAll(snap.notes);
      cell.isWrong = snap.isWrong;
    }

    _isGameOver = last.prevIsGameOver;

    // 상태 다시 계산
    _updateConflicts();
    _updateHighlights();

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _errorController.close(); // 이미 쓰고 있으면 같이 정리
    super.dispose();
  }
}

class _CellSnapshot {
  final int row;
  final int col;
  final int? value;
  final Set<int> notes;
  final bool isWrong;

  _CellSnapshot({
    required this.row,
    required this.col,
    required this.value,
    required this.notes,
    required this.isWrong,
  });
}

class _HistoryEntry {
  final List<_CellSnapshot> cells;
  final int prevWrongCount;
  final bool prevIsGameOver;

  _HistoryEntry({
    required this.cells,
    required this.prevWrongCount,
    required this.prevIsGameOver,
  });
}
