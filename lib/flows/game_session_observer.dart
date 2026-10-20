import 'dart:async';

import 'package:flutter/widgets.dart';

import '../controllers/sudoku_controller.dart';
import '../models/game_record.dart';
import '../models/game_status.dart';
import '../services/game_save_store.dart';
import '../services/record_store.dart';
import '../services/settings_store.dart';

/// 부수효과(기록, 세이브, 결과 시트 호출, 라이프사이클)를 status 전이마다 1회 처리한다 (D10).
class GameSessionObserver {
  static const saveDebounce = Duration(milliseconds: 500);

  GameSessionObserver(
    this._c,
    this._records,
    SettingsStore settings,
    this._saves, {
    required void Function(GameStatus status, bool isNewBest) onFinished,
  }) : _onFinished = onFinished,
       _prev = _c.status,
       _savedRevision = _c.revision {
    _c.addListener(_onChanged);
    _life = AppLifecycleListener(onHide: handleHide, onShow: handleShow);
    // 새 판이 시작되는 지점에서 기존 세이브를 덮어쓴다 (D18).
    _saves?.write(_c.snapshot());
  }

  final SudokuController _c;
  final RecordStore _records;
  final GameSaveStore? _saves;
  final void Function(GameStatus, bool) _onFinished;

  GameStatus _prev;
  int _savedRevision;
  Timer? _debounce;
  bool _resumeOnShow = false;
  late final AppLifecycleListener _life;
  bool _disposed = false;

  bool get _active =>
      _c.status == GameStatus.playing || _c.status == GameStatus.paused;

  void _onChanged() {
    final status = _c.status;
    if (status != _prev) {
      _prev = status;
      switch (status) {
        case GameStatus.solved:
          _debounce?.cancel();
          unawaited(_handleSolved());
          return;
        case GameStatus.failed:
          _debounce?.cancel();
          _saves?.clear();
          _onFinished(GameStatus.failed, false);
          return;
        case GameStatus.playing:
        case GameStatus.paused:
          break;
      }
    }
    if (_active && _saves != null && _c.revision != _savedRevision) {
      _debounce?.cancel();
      _debounce = Timer(saveDebounce, _saveNow);
    }
  }

  Future<void> _handleSolved() async {
    final elapsed = Duration(seconds: _c.elapsedMs ~/ 1000);
    var isNewBest = true;
    try {
      final best = await _records.bestTime(_c.difficulty);
      isNewBest = best == null || elapsed < best;
      await _saves?.clear();
      await _records.add(
        GameRecord(
          difficulty: _c.difficulty,
          elapsedSeconds: elapsed.inSeconds,
          wrongCount: _c.wrongCount,
          finishedAt: DateTime.now(),
          instantCheck: !_c.icEverOff,
        ),
      );
    } catch (e) {
      debugPrint('GameSessionObserver: 기록 저장 실패 ($e)');
    }
    if (_disposed) return;
    _onFinished(GameStatus.solved, isNewBest);
  }

  void _saveNow() {
    _debounce?.cancel();
    final saves = _saves;
    if (saves == null || !_active) return;
    _savedRevision = _c.revision;
    saves.write(_c.snapshot());
  }

  /// GameScreen 의 첫 프레임 이후 호출. reset() 후 재시작에도 쓴다.
  void startWhenVisible() {
    final state = WidgetsBinding.instance.lifecycleState;
    if (state == null || state == AppLifecycleState.resumed) {
      _c.resume();
    } else {
      _resumeOnShow = true;
    }
  }

  @visibleForTesting
  void handleHide() {
    if (_c.status == GameStatus.playing) {
      _c.pause();
      _resumeOnShow = true;
    }
    if (_active) _saveNow();
  }

  @visibleForTesting
  void handleShow() {
    if (!_resumeOnShow) return;
    _resumeOnShow = false;
    _c.resume();
  }

  void flushAndDispose() {
    if (_disposed) return;
    _debounce?.cancel();
    if (_active) _saveNow();
    _c.removeListener(_onChanged);
    _life.dispose();
    _disposed = true;
  }
}
