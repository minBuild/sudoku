import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_status.dart';

import '../fakes.dart';

/// [c] 의 효과를 모은다. broadcast 스트림이라 확인 전에 [_flush] 가 필요하다.
List<GameEffect> _record(SudokuController c) {
  final effects = <GameEffect>[];
  c.effects.listen(effects.add);
  return effects;
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

SudokuController playing(List<int> holes, {bool instantCheck = true}) {
  final c = SudokuController.fresh(
    puzzleWithHoles(holes),
    Difficulty.easy,
    instantCheck: instantCheck,
  );
  c.resume();
  return c;
}

void main() {
  test('생성 직후 paused', () {
    final c = SudokuController.fresh(
      puzzleWithHoles([0]),
      Difficulty.easy,
      instantCheck: true,
    );
    expect(c.status, GameStatus.paused);
    c.select(0);
    expect(c.selected, isNull); // playing 이 아니면 무시
    c.dispose();
  });

  test('undo 1회는 1단계만 되돌리고 wrongCount 는 유지', () {
    final c = playing([0, 1, 2]);
    c.select(0);
    c.input(solAt(0));
    c.select(1);
    c.input(wrongAt(1));
    expect(c.wrongCount, 1);

    c.undo();
    expect(c.valueAt(1), 0);
    expect(c.valueAt(0), solAt(0));
    expect(c.wrongCount, 1);

    c.undo();
    expect(c.valueAt(0), 0);
    c.dispose();
  });

  test('같은 값을 다시 넣으면 history 가 쌓이지 않는다', () {
    final c = playing([0, 1]);
    c.select(0);
    c.input(wrongAt(0));
    final rev = c.revision;
    c.input(wrongAt(0));
    expect(c.revision, rev);
    c.undo();
    expect(c.valueAt(0), 0);
    expect(c.canUndo, isFalse);
    c.dispose();
  });

  test('5회 틀리면 failed, 이후 입력과 undo 무시', () async {
    final c = playing([0, 1, 2, 3, 4, 5]);
    final effects = _record(c);
    for (var i = 0; i < 5; i++) {
      c.select(i);
      c.input(wrongAt(i));
    }
    expect(c.wrongCount, 5);
    expect(c.status, GameStatus.failed);
    await _flush();
    const expected = [
      GameEffect.selected,
      GameEffect.wrong,
      GameEffect.firstMistake,
      GameEffect.selected,
      GameEffect.wrong,
      GameEffect.selected,
      GameEffect.wrong,
      GameEffect.selected,
      GameEffect.wrong,
      GameEffect.selected,
      GameEffect.failed,
    ];
    expect(effects, expected);

    c.select(5);
    c.input(solAt(5));
    expect(c.valueAt(5), 0);
    c.undo();
    expect(c.valueAt(4), wrongAt(4));
    await _flush();
    expect(effects, expected);
    c.dispose();
  });

  test('첫 실수에 wrong 과 firstMistake 효과', () async {
    final c = playing([0, 1, 2]);
    final effects = _record(c);
    c.select(0);
    c.input(wrongAt(0));
    c.select(1);
    c.input(wrongAt(1));
    await _flush();
    expect(effects, [
      GameEffect.selected,
      GameEffect.wrong,
      GameEffect.firstMistake,
      GameEffect.selected,
      GameEffect.wrong,
    ]);
    c.dispose();
  });

  test('다 풀면 solved, 이후 undo 무시', () {
    final c = playing([0, 1]);
    c.select(0);
    c.input(solAt(0));
    c.select(1);
    c.input(solAt(1));
    expect(c.status, GameStatus.solved);
    expect(c.selected, isNull);
    c.undo();
    expect(c.valueAt(1), solAt(1));
    expect(c.status, GameStatus.solved);
    c.dispose();
  });

  test('메모 토글과 확정 입력 시 같은 행·열·박스 메모 정리', () {
    // 0번 칸(0행 0열)과 같은 행 1, 같은 열 9, 같은 박스 10, 무관한 칸 40
    final c = playing([0, 1, 9, 10, 40]);
    final n = solAt(0);
    final bit = 1 << (n - 1);

    c.toggleNote();
    for (final i in [1, 9, 10, 40]) {
      c.select(i);
      c.input(n);
      expect(c.notesAt(i) & bit, bit);
    }
    c.select(1);
    c.input(n); // 다시 누르면 꺼진다
    expect(c.notesAt(1) & bit, 0);
    c.input(n);

    c.toggleNote();
    c.select(0);
    c.input(n);
    expect(c.notesAt(1) & bit, 0);
    expect(c.notesAt(9) & bit, 0);
    expect(c.notesAt(10) & bit, 0);
    expect(c.notesAt(40) & bit, bit);
    c.dispose();
  });

  test('이미 다 채운 숫자는 입력 무시', () {
    // 0행은 1..9 이므로 빈칸 0,1 의 정답은 1,2 이고 5 는 9개 모두 놓여 있다.
    final c = playing([0, 1]);
    expect(solAt(0), 1);
    expect(c.remaining(1), 1);
    expect(c.remaining(5), 0);
    c.select(0);
    c.input(5);
    expect(c.valueAt(0), 0);
    expect(c.wrongCount, 0);
    expect(c.canUndo, isFalse);
    c.dispose();
  });

  test('fromSave(snapshot()) 복원 상태가 같다', () {
    final c = playing([0, 1, 2, 3]);
    c.select(0);
    c.input(wrongAt(0));
    c.select(1);
    c.toggleNote();
    c.input(3);
    c.input(5);
    c.setInstantCheck(false);

    final s = c.snapshot();
    final r = SudokuController.fromSave(s);
    for (var i = 0; i < 81; i++) {
      expect(r.valueAt(i), c.valueAt(i));
      expect(r.notesAt(i), c.notesAt(i));
      expect(r.isGiven(i), c.isGiven(i));
    }
    expect(r.wrongCount, c.wrongCount);
    expect(r.instantCheck, isFalse);
    expect(r.icEverOff, isTrue);
    expect(r.difficulty, c.difficulty);
    expect(r.elapsedMs, s.elapsedMs);
    expect(r.canUndo, isFalse);
    expect(r.status, GameStatus.paused);
    c.dispose();
    r.dispose();
  });

  test('즉시 체크 OFF 에서는 wrongCount 가 변하지 않고 충돌 효과를 낸다', () async {
    final c = playing([0, 1], instantCheck: false);
    final effects = _record(c);
    c.select(0);
    c.input(solAt(1)); // 같은 행에 이미 있는 값 → 충돌
    await _flush();
    expect(c.wrongCount, 0);
    expect(c.isWrongAt(0), isFalse);
    expect(c.isConflictedAt(0), isTrue);
    expect(effects, [GameEffect.selected, GameEffect.conflict]);
    c.dispose();
  });

  test('resume/pause 는 멱등이고 종료 상태에서는 no-op', () {
    final c = SudokuController.fresh(
      puzzleWithHoles([0]),
      Difficulty.easy,
      instantCheck: true,
    );
    c.resume();
    c.resume();
    expect(c.status, GameStatus.playing);
    c.pause();
    c.pause();
    expect(c.status, GameStatus.paused);

    c.resume();
    c.select(0);
    c.input(solAt(0));
    expect(c.status, GameStatus.solved);
    c.pause();
    expect(c.status, GameStatus.solved);
    c.resume();
    expect(c.status, GameStatus.solved);
    c.dispose();
  });

  test('reset 은 같은 퍼즐로 paused 상태로 돌아간다', () {
    final c = playing([0, 1]);
    c.select(0);
    c.input(wrongAt(0));
    c.reset();
    expect(c.status, GameStatus.paused);
    expect(c.wrongCount, 0);
    expect(c.valueAt(0), 0);
    expect(c.canUndo, isFalse);
    expect(c.elapsedSeconds.value, 0);
    c.dispose();
  });

  group('효과 시퀀스', () {
    test('같은 칸을 다시 선택하면 무음', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c
        ..select(0)
        ..select(0);
      await _flush();
      expect(effects, [GameEffect.selected]);
      c.dispose();
    });

    test('given 칸 선택은 selected, 입력은 무음', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c.select(5);
      expect(c.isGiven(5), isTrue);
      c.input(3);
      await _flush();
      expect(effects, [GameEffect.selected]);
      c.dispose();
    });

    test('remaining 이 0 인 숫자는 무음', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c.select(0);
      expect(c.remaining(5), 0);
      c.input(5);
      await _flush();
      expect(effects, [GameEffect.selected]);
      c.dispose();
    });

    test('같은 숫자를 다시 넣으면 무음', () async {
      final c = playing([0, 1, 2]);
      final effects = _record(c);
      c
        ..select(0)
        ..input(solAt(0))
        ..input(solAt(0));
      await _flush();
      expect(effects, [GameEffect.selected, GameEffect.placed]);
      c.dispose();
    });

    test('비어 있는 칸 erase 는 무음', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c
        ..select(0)
        ..erase();
      await _flush();
      expect(effects, [GameEffect.selected]);
      c.dispose();
    });

    test('erase · undo 는 accepted', () async {
      final c = playing([0, 1, 2]);
      final effects = _record(c);
      c
        ..select(0)
        ..input(solAt(0))
        ..erase()
        ..undo();
      await _flush();
      expect(effects, [
        GameEffect.selected,
        GameEffect.placed,
        GameEffect.accepted,
        GameEffect.accepted,
      ]);
      c.dispose();
    });

    test('히스토리가 없을 때 undo 는 무음', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c.undo();
      await _flush();
      expect(effects, isEmpty);
      c.dispose();
    });

    test('마지막 칸을 넣으면 solved 만', () async {
      final c = playing([0]);
      final effects = _record(c);
      c
        ..select(0)
        ..input(solAt(0));
      await _flush();
      expect(effects, [GameEffect.selected, GameEffect.solved]);
      c.dispose();
    });

    test('즉시 체크 OFF 에서 충돌 없는 오답은 accepted', () async {
      // 0번 칸에 2: 0행의 2(1번 칸)와 0열의 2(27번 칸)를 비워 충돌이 없다.
      final c = playing([0, 1, 27], instantCheck: false);
      final effects = _record(c);
      c
        ..select(0)
        ..input(2);
      expect(solAt(0), isNot(2));
      expect(c.isConflictedAt(0), isFalse);
      await _flush();
      expect(effects, [GameEffect.selected, GameEffect.placed]);
      c.dispose();
    });

    test('toggleNote 는 accepted, 메모 입력은 noted', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c
        ..select(0)
        ..toggleNote()
        ..input(3);
      await _flush();
      expect(effects, [
        GameEffect.selected,
        GameEffect.accepted,
        GameEffect.noted,
      ]);
      c.dispose();
    });

    test('reset 은 무음', () async {
      final c = playing([0, 1]);
      final effects = _record(c);
      c
        ..select(0)
        ..input(wrongAt(0));
      await _flush();
      effects.clear();
      c.reset();
      await _flush();
      expect(effects, isEmpty);
      c.dispose();
    });
  });

  group('힌트', () {
    test('hintTarget: 선택 칸이 비었거나 오답이면 그 칸, 아니면 행 우선 첫 칸', () {
      final c = playing([5, 20, 40]);
      expect(c.hintTarget, 5); // 선택 없음 → 행 우선
      c.select(40);
      expect(c.hintTarget, 40);
      c.select(0); // given
      expect(c.hintTarget, 5);
      c.select(20);
      c.input(solAt(20)); // 이미 정답
      expect(c.hintTarget, 5);
      c.select(40);
      c.input(wrongAt(40)); // 오답
      c.select(0);
      expect(c.hintTarget, 5);
      c.select(40);
      expect(c.hintTarget, 40);
      c.dispose();
    });

    test('hintTarget: 다 맞으면 null', () {
      final c = SudokuController.fresh(
        puzzleWithHoles([]),
        Difficulty.easy,
        instantCheck: true,
      );
      expect(c.hintTarget, isNull);
      c.dispose();
    });

    test('hint 는 값을 채우고 피어 메모를 정리하고 선택을 옮긴다', () async {
      final c = playing([0, 1, 9, 30]);
      final effects = _record(c);
      final n = solAt(0);
      c.select(1);
      c.toggleNote();
      c.input(n); // 같은 행의 메모
      c.toggleNote();
      c.select(30);
      await _flush();
      effects.clear();
      c.select(0);
      await _flush();
      effects.clear();

      expect(c.hint(), isTrue);
      await _flush();
      expect(c.valueAt(0), n);
      expect(c.notesAt(1) & (1 << (n - 1)), 0);
      expect(c.selected, 0);
      expect(c.hintsUsed, 1);
      expect(effects, [GameEffect.hinted]);
      c.dispose();
    });

    test('마지막 칸을 힌트로 채우면 solved 효과만', () async {
      final c = playing([7]);
      final effects = _record(c);
      expect(c.hint(), isTrue);
      await _flush();
      expect(c.status, GameStatus.solved);
      expect(c.selected, isNull);
      expect(effects, [GameEffect.solved]);
      c.dispose();
    });

    test('paused 에서 hint() 는 false 이고 효과 없음', () async {
      final c = playing([0, 1]);
      c.pause();
      final effects = _record(c);
      expect(c.hint(), isFalse);
      await _flush();
      expect(effects, isEmpty);
      expect(c.hintsUsed, 0);
      c.dispose();
    });

    test('paused 에서 hint(allowPaused) 는 적용하고 paused 유지, 시간 그대로', () async {
      final c = playing([0, 1]);
      c.pause();
      final before = c.elapsedMs;
      expect(c.hint(allowPaused: true), isTrue);
      expect(c.status, GameStatus.paused);
      expect(c.hintsUsed, 1);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(c.elapsedMs, before);
      c.dispose();
    });

    test('solved/failed 에서는 allowPaused 여도 false', () {
      final solved = playing([0]);
      solved.select(0);
      solved.input(solAt(0));
      expect(solved.status, GameStatus.solved);
      expect(solved.hint(allowPaused: true), isFalse);
      solved.dispose();

      final failed = failedGame();
      expect(failed.hint(allowPaused: true), isFalse);
      failed.dispose();
    });

    test('undo 해도 hintsUsed 유지, reset 이면 0', () {
      final c = playing([0, 1]);
      c.hint();
      c.undo();
      expect(c.valueAt(0), 0);
      expect(c.hintsUsed, 1);
      c.reset();
      expect(c.hintsUsed, 0);
      c.dispose();
    });
  });

  group('continueAfterFail', () {
    test('failed 가 아니면 false', () {
      final c = playing([0, 1]);
      expect(c.continueAfterFail(), isFalse);
      c.dispose();
    });

    test('오답 값만 지우고 메모 유지, 실수 0, 히스토리 비움, paused, revision 증가', () async {
      final c = failedGame(noteAt: 70);
      final effects = _record(c);
      final notes = c.notesAt(70);
      final ms = c.elapsedMs;
      final rev = c.revision;
      c.hint(); // failed 라 무시
      expect(c.continueAfterFail(), isTrue);
      await _flush();
      expect(effects, isEmpty);
      expect(c.status, GameStatus.paused);
      expect(c.wrongCount, 0);
      expect(c.canUndo, isFalse);
      expect(c.revision, greaterThan(rev));
      expect(c.elapsedMs, ms);
      for (var i = 0; i < 81; i++) {
        expect(c.isWrongAt(i), isFalse, reason: '$i');
      }
      expect(c.valueAt(0), solAt(0)); // 정답은 남는다
      expect(c.notesAt(70), notes);
      c.resume();
      expect(c.status, GameStatus.playing);
      c.dispose();
    });

    test('이어 도전 뒤 다시 5회 실패하면 다시 이어 갈 수 있다', () {
      final c = failedGame();
      c.continueAfterFail();
      c.resume();
      for (var k = 0; k < SudokuController.maxWrong; k++) {
        c.select(72 + k);
        c.input(wrongAt(72 + k));
      }
      expect(c.status, GameStatus.failed);
      expect(c.continueAfterFail(), isTrue);
      c.dispose();
    });
  });

  test('snapshot ↔ fromSave 가 weeklyBoard·hintsUsed 를 보존한다', () {
    final c = SudokuController.fresh(
      puzzleWithHoles([0, 1, 2]),
      Difficulty.hard,
      instantCheck: true,
      weeklyBoard: '2026-W44_hard_g1',
    )..resume();
    c.hint();
    final r = SudokuController.fromSave(c.snapshot());
    expect(r.weeklyBoard, '2026-W44_hard_g1');
    expect(r.hintsUsed, 1);
    expect(r.valueAt(0), solAt(0));
    c.dispose();
    r.dispose();
  });
}

/// 0 은 정답, 63~67 에 오답 5개로 failed. [noteAt] 칸엔 메모 하나.
/// 오답 숫자는 오른쪽 칸의 정답이라 7·8행을 비워 둔다 (fakes.wrongAt).
SudokuController failedGame({int? noteAt}) {
  final c = playing([0, for (var i = 63; i < 81; i++) i]);
  c.select(0);
  c.input(solAt(0));
  if (noteAt != null) {
    c.select(noteAt);
    c.toggleNote();
    c.input(3);
    c.toggleNote();
  }
  for (var k = 0; k < SudokuController.maxWrong; k++) {
    c.select(63 + k);
    c.input(wrongAt(63 + k));
  }
  expect(c.status, GameStatus.failed);
  return c;
}
