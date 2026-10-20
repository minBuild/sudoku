import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/saved_game.dart';
import 'package:sudoku/services/game_save_store.dart';

import '../fakes.dart';

const key = 'sudoku_jang_save_v1';

SavedGame sample() {
  final c = SudokuController.fresh(
    puzzleWithHoles([0, 1, 2, 3]),
    Difficulty.expert,
    instantCheck: true,
  )..resume();
  c.select(0);
  c.input(solAt(0));
  final s = c.snapshot();
  c.dispose();
  return s;
}

void main() {
  test('write → load → clear, meta 갱신', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = GameSaveStore(prefs);
    expect(store.meta.value, isNull);
    expect(store.load(), isA<LoadNone>());

    await store.write(sample());
    expect(store.meta.value?.difficulty, Difficulty.expert);
    expect(store.meta.value?.filledRatio, closeTo(0.25, 1e-9));

    final r = store.load();
    expect(r, isA<LoadOk>());
    expect((r as LoadOk).game.current[0], solAt(0));

    // 새 인스턴스는 생성 시 동기로 meta 를 읽는다.
    expect(GameSaveStore(prefs).meta.value, isNotNull);

    await store.clear();
    expect(store.meta.value, isNull);
    expect(store.load(), isA<LoadNone>());
  });

  test('incompatible 이면 즉시 삭제', () async {
    final bad = sample().toJson()..['v'] = 99;
    SharedPreferences.setMockInitialValues({key: jsonEncode(bad)});
    final prefs = await SharedPreferences.getInstance();
    final store = GameSaveStore(prefs);
    expect(store.meta.value, isNull);
    expect(store.load(), isA<LoadIncompatible>());
    await Future<void>.delayed(Duration.zero);
    expect(prefs.getString(key), isNull);
    expect(store.load(), isA<LoadNone>());
  });

  test('JSON 이 깨져도 incompatible', () async {
    SharedPreferences.setMockInitialValues({key: '{oops'});
    final prefs = await SharedPreferences.getInstance();
    expect(GameSaveStore(prefs).load(), isA<LoadIncompatible>());
  });
}
