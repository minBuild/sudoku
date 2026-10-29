import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../models/difficulty.dart';
import '../models/game_status.dart';
import '../models/saved_game.dart';
import '../models/sudoku_puzzle.dart';

class _Snapshot {
  _Snapshot(this.values, this.notes);
  final Uint8List values;
  final Uint16List notes;
}

/// 한 판의 상태. I/O, BuildContext, prefs 를 갖지 않는다.
class SudokuController extends ChangeNotifier {
  static const maxWrong = 5;
  static const maxHistory = 200;

  /// 각 칸의 같은 행·열·박스 칸 (자기 자신 제외, 20개).
  static final List<List<int>> peersOf = List.generate(81, (i) {
    final r = i ~/ 9, c = i % 9;
    final br = r ~/ 3 * 3, bc = c ~/ 3 * 3;
    final set = <int>{};
    for (var k = 0; k < 9; k++) {
      set.add(r * 9 + k);
      set.add(k * 9 + c);
      set.add((br + k ~/ 3) * 9 + bc + k % 3);
    }
    set.remove(i);
    return List.unmodifiable(set);
  });

  SudokuController.fresh(
    SudokuPuzzle p,
    this.difficulty, {
    required bool instantCheck,
    this.weeklyBoard,
  }) : _sol = _flatten(p.solution),
       _init = _flatten(p.initial),
       _values = _flatten(p.initial),
       _notes = Uint16List(81),
       _instantCheck = instantCheck,
       _icEverOff = !instantCheck,
       _offsetMs = 0,
       elapsedSeconds = ValueNotifier(0) {
    _recomputeConflicts();
  }

  /// 저장된 판에서 복원. undo 스택은 비어 있다.
  SudokuController.fromSave(SavedGame s)
    : difficulty = s.difficulty,
      _sol = Uint8List.fromList(s.solution),
      _init = Uint8List.fromList(s.initial),
      _values = Uint8List.fromList(s.current),
      _notes = Uint16List.fromList(s.notes),
      _instantCheck = s.instantCheck,
      _icEverOff = s.icEverOff,
      _wrongCount = s.wrongCount,
      _offsetMs = s.elapsedMs,
      weeklyBoard = s.weeklyBoard,
      _hintsUsed = s.hintsUsed,
      elapsedSeconds = ValueNotifier(s.elapsedMs ~/ 1000) {
    _recomputeConflicts();
  }

  final Difficulty difficulty;

  /// 주간 판이면 보드 ID (`WeeklyBoard.id`).
  final String? weeklyBoard;
  final Uint8List _sol;
  final Uint8List _init;
  final Uint8List _values;
  final Uint16List _notes;
  final _conflicts = List<bool>.filled(81, false);
  final _history = <_Snapshot>[];
  final _effects = StreamController<GameEffect>.broadcast();
  final _stopwatch = Stopwatch();
  Timer? _ticker;

  /// 표시용 경과 초. 실제 시간은 Stopwatch + 오프셋.
  final ValueNotifier<int> elapsedSeconds;

  GameStatus _status = GameStatus.paused;
  int _offsetMs;
  int _revision = 0;
  int? _selected;
  int _wrongCount = 0;
  bool _instantCheck;
  bool _icEverOff;
  bool _noteMode = false;
  int _hintsUsed = 0;

  GameStatus get status => _status;
  Stream<GameEffect> get effects => _effects.stream;
  int get revision => _revision;
  int? get selected => _selected;
  int get wrongCount => _wrongCount;
  bool get instantCheck => _instantCheck;
  bool get icEverOff => _icEverOff;
  bool get noteMode => _noteMode;
  bool get canUndo => _history.isNotEmpty;
  int get elapsedMs => _offsetMs + _stopwatch.elapsedMilliseconds;
  int get hintsUsed => _hintsUsed;

  int valueAt(int i) => _values[i];
  int notesAt(int i) => _notes[i];
  bool isGiven(int i) => _init[i] != 0;

  bool isWrongAt(int i) =>
      _instantCheck && _values[i] != 0 && _values[i] != _sol[i];

  bool isConflictedAt(int i) => _conflicts[i];

  /// 아직 놓을 수 있는 n 의 개수 (오답으로 표시된 칸은 세지 않는다).
  int remaining(int n) {
    var placed = 0;
    for (var i = 0; i < 81; i++) {
      if (_values[i] == n && !isWrongAt(i)) placed++;
    }
    return 9 - placed;
  }

  // -------------------- 상태 전이 --------------------

  void resume() {
    if (_status != GameStatus.paused) return;
    _status = GameStatus.playing;
    _stopwatch.start();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void pause() {
    if (_status != GameStatus.playing) return;
    _stopTime();
    _status = GameStatus.paused;
    notifyListeners();
  }

  void _stopTime() {
    _stopwatch.stop();
    _ticker?.cancel();
    _ticker = null;
    _tick();
  }

  void _tick() => elapsedSeconds.value = elapsedMs ~/ 1000;

  // -------------------- 입력 --------------------

  bool get _playing => _status == GameStatus.playing;

  void select(int i) {
    if (!_playing || i < 0 || i > 80 || _selected == i) return;
    _selected = i;
    _effects.add(GameEffect.selected);
    _changed();
  }

  void toggleNote() {
    if (!_playing) return;
    _effects.add(GameEffect.accepted);
    _noteMode = !_noteMode;
    notifyListeners();
  }

  void input(int n) {
    final i = _selected;
    if (!_playing || i == null || isGiven(i) || n < 1 || n > 9) return;

    if (_noteMode) {
      _pushHistory();
      _values[i] = 0;
      _notes[i] ^= 1 << (n - 1);
      _recomputeConflicts();
      _effects.add(GameEffect.accepted);
      _changed();
      return;
    }

    if (_values[i] == n || remaining(n) == 0) return;

    _pushHistory();
    _values[i] = n;
    _notes[i] = 0;
    final wrong = n != _sol[i];
    if (!wrong) {
      final mask = ~(1 << (n - 1)) & 0x1FF;
      for (final p in peersOf[i]) {
        _notes[p] &= mask;
      }
    }
    _recomputeConflicts();

    // 입력 1번에 결과 효과 1개. 첫 오답만 firstMistake 가 뒤따른다.
    var fx = GameEffect.accepted;
    if (_instantCheck && wrong) {
      _wrongCount++;
      fx = GameEffect.wrong;
      if (_wrongCount >= maxWrong) {
        _stopTime();
        _status = GameStatus.failed;
        fx = GameEffect.failed;
      }
    } else if (!_instantCheck && _conflicts[i]) {
      fx = GameEffect.conflict;
    }
    if (_isSolved()) {
      _stopTime();
      _status = GameStatus.solved;
      _selected = null;
      fx = GameEffect.solved;
    }
    _effects.add(fx);
    if (fx == GameEffect.wrong && _wrongCount == 1) {
      _effects.add(GameEffect.firstMistake);
    }
    _changed();
  }

  void erase() {
    final i = _selected;
    if (!_playing || i == null || isGiven(i)) return;
    if (_values[i] == 0 && _notes[i] == 0) return;
    _pushHistory();
    _values[i] = 0;
    _notes[i] = 0;
    _recomputeConflicts();
    _effects.add(GameEffect.accepted);
    _changed();
  }

  /// 보드 1단계 복원. wrongCount 는 되돌리지 않는다 (D12).
  void undo() {
    if (!_playing || _history.isEmpty) return;
    final s = _history.removeLast();
    _values.setAll(0, s.values);
    _notes.setAll(0, s.notes);
    _recomputeConflicts();
    _effects.add(GameEffect.accepted);
    _changed();
  }

  /// 힌트가 채울 칸. 선택 칸이 비었거나 틀렸으면 그 칸, 아니면 행 우선 첫 대상 칸.
  int? get hintTarget {
    final sel = _selected;
    if (sel != null && !isGiven(sel) && _values[sel] != _sol[sel]) return sel;
    for (var i = 0; i < 81; i++) {
      if (_values[i] != _sol[i]) return i;
    }
    return null;
  }

  /// [hintTarget] 에 정답을 채운다. [allowPaused] 면 광고 직후 paused 에서도 적용한다.
  /// 타이머는 시작하지 않는다. undo 해도 [hintsUsed] 는 줄지 않는다.
  bool hint({bool allowPaused = false}) {
    final okStatus =
        _status == GameStatus.playing ||
        (allowPaused && _status == GameStatus.paused);
    if (!okStatus) return false;
    final i = hintTarget;
    if (i == null) return false;
    _pushHistory();
    final n = _sol[i];
    _values[i] = n;
    _notes[i] = 0;
    final mask = ~(1 << (n - 1)) & 0x1FF;
    for (final p in peersOf[i]) {
      _notes[p] &= mask;
    }
    _recomputeConflicts();
    _hintsUsed++;
    _selected = i;
    var fx = GameEffect.hinted;
    if (_isSolved()) {
      _stopTime();
      _status = GameStatus.solved;
      _selected = null;
      fx = GameEffect.solved;
    }
    _effects.add(fx);
    _changed();
    return true;
  }

  /// 5회 실패 뒤 이어 풀기. 오답 칸 값만 지우고(메모 유지) 실수 0, paused 로 돌아간다.
  /// 시간과 [hintsUsed] 는 유지한다. undo 로 오답을 되살리지 못하게 히스토리를 비운다.
  bool continueAfterFail() {
    if (_status != GameStatus.failed) return false;
    for (var i = 0; i < 81; i++) {
      if (isWrongAt(i)) _values[i] = 0;
    }
    _wrongCount = 0;
    _history.clear();
    _status = GameStatus.paused;
    _recomputeConflicts();
    _changed(); // notifyListeners 만으로는 revision 이 안 올라 세이브되지 않는다
    return true;
  }

  void setInstantCheck(bool v) {
    if (_instantCheck == v) return;
    _instantCheck = v;
    if (!v) _icEverOff = true;
    _changed();
  }

  /// 같은 퍼즐을 처음부터. 상태는 paused 로 돌아간다.
  void reset() {
    _stopwatch
      ..stop()
      ..reset();
    _ticker?.cancel();
    _ticker = null;
    _offsetMs = 0;
    elapsedSeconds.value = 0;
    _values.setAll(0, _init);
    _notes.fillRange(0, 81, 0);
    _history.clear();
    _wrongCount = 0;
    _hintsUsed = 0;
    _selected = null;
    _noteMode = false;
    _icEverOff = !_instantCheck;
    _status = GameStatus.paused;
    _recomputeConflicts();
    _changed();
  }

  SavedGame snapshot() => SavedGame(
    difficulty: difficulty,
    solution: Uint8List.fromList(_sol),
    initial: Uint8List.fromList(_init),
    current: Uint8List.fromList(_values),
    notes: Uint16List.fromList(_notes),
    elapsedMs: elapsedMs,
    wrongCount: _wrongCount,
    instantCheck: _instantCheck,
    icEverOff: _icEverOff,
    savedAt: DateTime.now(),
    weeklyBoard: weeklyBoard,
    hintsUsed: _hintsUsed,
  );

  // -------------------- 내부 --------------------

  void _pushHistory() {
    _history.add(
      _Snapshot(Uint8List.fromList(_values), Uint16List.fromList(_notes)),
    );
    if (_history.length > maxHistory) _history.removeAt(0);
  }

  void _changed() {
    _revision++;
    notifyListeners();
  }

  bool _isSolved() {
    for (var i = 0; i < 81; i++) {
      if (_values[i] != _sol[i]) return false;
    }
    return true;
  }

  void _recomputeConflicts() {
    for (var i = 0; i < 81; i++) {
      final v = _values[i];
      var hit = false;
      if (v != 0) {
        for (final p in peersOf[i]) {
          if (_values[p] == v) {
            hit = true;
            break;
          }
        }
      }
      _conflicts[i] = hit;
    }
  }

  static Uint8List _flatten(List<List<int>> g) =>
      Uint8List.fromList([for (final row in g) ...row]);

  @override
  void dispose() {
    _stopwatch.stop();
    _ticker?.cancel();
    _effects.close();
    elapsedSeconds.dispose();
    super.dispose();
  }
}
