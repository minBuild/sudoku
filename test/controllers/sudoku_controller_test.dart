import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_status.dart';

import '../fakes.dart';

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

  test('5회 틀리면 failed, 이후 입력과 undo 무시', () {
    final c = playing([0, 1, 2, 3, 4, 5]);
    final effects = <GameEffect>[];
    c.effects.listen(effects.add);
    for (var i = 0; i < 5; i++) {
      c.select(i);
      c.input(wrongAt(i));
    }
    expect(c.wrongCount, 5);
    expect(c.status, GameStatus.failed);

    c.select(5);
    c.input(solAt(5));
    expect(c.valueAt(5), 0);
    c.undo();
    expect(c.valueAt(4), wrongAt(4));
    c.dispose();
  });

  test('첫 실수에 wrong 과 firstMistake 효과', () async {
    final c = playing([0, 1, 2]);
    final effects = <GameEffect>[];
    c.effects.listen(effects.add);
    c.select(0);
    c.input(wrongAt(0));
    c.select(1);
    c.input(wrongAt(1));
    await Future<void>.delayed(Duration.zero);
    expect(effects, [
      GameEffect.wrong,
      GameEffect.firstMistake,
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
    final effects = <GameEffect>[];
    c.effects.listen(effects.add);
    c.select(0);
    c.input(solAt(1)); // 같은 행에 이미 있는 값 → 충돌
    await Future<void>.delayed(Duration.zero);
    expect(c.wrongCount, 0);
    expect(c.isWrongAt(0), isFalse);
    expect(c.isConflictedAt(0), isTrue);
    expect(effects, [GameEffect.conflict]);
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
}
