import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/flows/game_session_observer.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_status.dart';
import 'package:sudoku/models/saved_game.dart';
import 'package:sudoku/services/game_save_store.dart';
import 'package:sudoku/services/record_store.dart';
import 'package:sudoku/services/settings_store.dart';

import '../fakes.dart';

class SpySaves extends GameSaveStore {
  SpySaves(super.prefs);

  int writes = 0;
  int clears = 0;

  @override
  Future<void> write(SavedGame game) {
    writes++;
    return super.write(game);
  }

  @override
  Future<void> clear() {
    clears++;
    return super.clear();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late RecordStore records;
  late SpySaves saves;
  late SudokuController c;
  late List<(GameStatus, bool)> finished;
  late GameSessionObserver obs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    records = RecordStore(prefs);
    saves = SpySaves(prefs);
    finished = [];
  });

  void start(List<int> holes) {
    c = SudokuController.fresh(
      puzzleWithHoles(holes),
      Difficulty.easy,
      instantCheck: true,
    );
    obs = GameSessionObserver(
      c,
      records,
      SettingsStore(prefs),
      saves,
      onFinished: (s, best) => finished.add((s, best)),
    );
  }

  tearDown(() {
    obs.flushAndDispose();
    c.dispose();
  });

  test('생성 시 세이브를 1회 덮어쓰고 입력은 500ms 디바운스로 저장', () {
    fakeAsync((fa) {
      start([0, 1]);
      expect(saves.writes, 1);
      obs.startWhenVisible();
      expect(c.status, GameStatus.playing);
      c.select(0);
      c.input(wrongAt(0));
      fa.elapse(const Duration(milliseconds: 400));
      expect(saves.writes, 1);
      fa.elapse(const Duration(milliseconds: 200));
      expect(saves.writes, 2);
    });
  });

  test('solved 직후 디바운스 저장이 실행되지 않고 기록·onFinished 는 1회', () {
    fakeAsync((fa) {
      start([0, 1]);
      obs.startWhenVisible();
      c.select(0);
      c.input(solAt(0)); // 디바운스 예약
      c.select(1);
      c.input(solAt(1)); // solved
      expect(c.status, GameStatus.solved);
      final writes = saves.writes;
      fa.elapse(const Duration(seconds: 2));
      fa.flushMicrotasks();
      expect(saves.writes, writes);
      expect(saves.clears, 1);
      expect(finished, [(GameStatus.solved, true)]);

      // 이후 알림이 와도 다시 처리하지 않는다.
      c.resume();
      c.pause();
      fa.elapse(const Duration(seconds: 1));
      expect(finished.length, 1);
    });
    // 기록은 정확히 1개
    late List<int> lens;
    fakeAsync((fa) {
      records.loadAll().then((r) => lens = [r.length]);
      fa.flushMicrotasks();
    });
    expect(lens, [1]);
  });

  test('failed 가 되면 세이브를 삭제하고 onFinished(failed)', () {
    fakeAsync((fa) {
      start([0, 1, 2, 3, 4, 5]);
      obs.startWhenVisible();
      for (var i = 0; i < 5; i++) {
        c.select(i);
        c.input(wrongAt(i));
      }
      fa.elapse(const Duration(seconds: 1));
      expect(c.status, GameStatus.failed);
      expect(saves.clears, 1);
      expect(saves.meta.value, isNull);
      expect(finished, [(GameStatus.failed, false)]);
    });
  });

  test('_resumeOnShow 가 false 이면 onShow 가 와도 resume 하지 않는다', () {
    start([0]);
    expect(c.status, GameStatus.paused);
    obs.handleShow();
    expect(c.status, GameStatus.paused);
  });

  test('onHide → onShow 는 pause 후 resume', () {
    start([0, 1]);
    obs.startWhenVisible();
    obs.handleHide();
    expect(c.status, GameStatus.paused);
    obs.handleShow();
    expect(c.status, GameStatus.playing);
    obs.handleShow(); // 두 번째는 no-op
    expect(c.status, GameStatus.playing);
  });

  test('solved 상태에서 onShow 가 와도 status 그대로', () {
    fakeAsync((fa) {
      start([0]);
      obs.startWhenVisible();
      c.select(0);
      c.input(solAt(0));
      fa.flushMicrotasks();
      obs.handleHide();
      obs.handleShow();
      expect(c.status, GameStatus.solved);
    });
  });
}
