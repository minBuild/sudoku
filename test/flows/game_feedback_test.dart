import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/flows/game_feedback.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/services/settings_store.dart';
import 'package:sudoku/services/sound/sound_service.dart';

import '../fakes.dart';

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  late SudokuController c;
  late FakeSound sound;
  late SettingsStore settings;
  late GameFeedback fb;
  var haptics = 0;

  Future<void> setUpWith(
    List<int> holes, {
    bool instantCheck = true,
    bool soundOn = true,
  }) async {
    SharedPreferences.setMockInitialValues({'settings_sound_v1': soundOn});
    settings = SettingsStore(await SharedPreferences.getInstance());
    c = SudokuController.fresh(
      puzzleWithHoles(holes),
      Difficulty.easy,
      instantCheck: instantCheck,
    )..resume();
    sound = FakeSound();
    haptics = 0;
    fb = GameFeedback(c, sound, settings, haptic: () => haptics++);
  }

  /// 지금까지 기록을 비우고 [act] 한 번의 결과만 본다.
  Future<void> only(void Function() act) async {
    await _flush();
    sound.played.clear();
    haptics = 0;
    act();
    await _flush();
  }

  tearDown(() {
    fb.dispose();
    c.dispose();
  });

  test('selected → tap 0.3, 햅틱 없음', () async {
    await setUpWith([0, 1]);
    await only(() => c.select(0));
    expect(sound.played, [(SoundCue.tap, 0.3)]);
    expect(haptics, 0);
  });

  test('accepted → tap 1.0, 햅틱 없음', () async {
    await setUpWith([0, 1]);
    c.select(0);
    await only(() => c.input(solAt(0)));
    expect(sound.played, [(SoundCue.tap, 1.0)]);
    expect(haptics, 0);
  });

  test('wrong → wrong + 햅틱. 뒤따르는 firstMistake 는 무음', () async {
    await setUpWith([0, 1, 2]);
    c.select(0);
    await only(() => c.input(wrongAt(0)));
    expect(sound.played, [(SoundCue.wrong, 1.0)]);
    expect(haptics, 1);
  });

  test('conflict → wrong + 햅틱', () async {
    await setUpWith([0, 1], instantCheck: false);
    c.select(0);
    await only(() => c.input(solAt(1)));
    expect(sound.played, [(SoundCue.wrong, 1.0)]);
    expect(haptics, 1);
  });

  test('failed → failed + 햅틱 (wrong 과 겹치지 않음)', () async {
    await setUpWith([0, 1, 2, 3, 4, 5]);
    for (var i = 0; i < 4; i++) {
      c
        ..select(i)
        ..input(wrongAt(i));
    }
    c.select(4);
    await only(() => c.input(wrongAt(4)));
    expect(sound.played, [(SoundCue.failed, 1.0)]);
    expect(haptics, 1);
  });

  test('solved → solved, 햅틱 없음', () async {
    await setUpWith([0]);
    c.select(0);
    await only(() => c.input(solAt(0)));
    expect(sound.played, [(SoundCue.solved, 1.0)]);
    expect(haptics, 0);
  });

  test('soundEnabled=false 면 소리 0개, 햅틱은 유지', () async {
    await setUpWith([0, 1, 2], soundOn: false);
    c
      ..select(0)
      ..input(solAt(0))
      ..select(1)
      ..input(wrongAt(1));
    await _flush();
    expect(sound.played, isEmpty);
    expect(haptics, 1);
  });

  test('dispose 뒤에는 아무것도 기록하지 않는다', () async {
    await setUpWith([0, 1, 2]);
    fb.dispose();
    c
      ..select(0)
      ..input(wrongAt(0));
    await _flush();
    expect(sound.played, isEmpty);
    expect(haptics, 0);
  });
}
