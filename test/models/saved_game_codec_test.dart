import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/saved_game.dart';

import '../fakes.dart';

Map<String, dynamic> validJson() {
  final c = SudokuController.fresh(
    puzzleWithHoles([0, 1, 2, 10]),
    Difficulty.hard,
    instantCheck: true,
  )..resume();
  c.select(0);
  c.input(solAt(0));
  c.select(1);
  c.toggleNote();
  c.input(4);
  final json = jsonDecode(jsonEncode(c.snapshot().toJson())) as Map;
  c.dispose();
  return json.cast<String, dynamic>();
}

String replaceAt(String s, int i, String ch) =>
    s.substring(0, i) + ch + s.substring(i + 1);

void main() {
  test('저장 후 다시 읽으면 같다', () {
    final json = validJson();
    final s = SavedGame.tryFromJson(json)!;
    expect(s.toJson()..remove('savedAt'), Map.of(json)..remove('savedAt'));
    expect(s.difficulty, Difficulty.hard);
    expect(s.current[0], solAt(0));
    expect(s.notes[1], 1 << 3);
    expect(s.filledRatio, closeTo(1 / 4, 1e-9));
  });

  test('v 가 다르면 null', () {
    expect(SavedGame.tryFromJson(validJson()..['v'] = 2), isNull);
  });

  test('길이가 81 이 아니면 null', () {
    for (final key in ['sol', 'init', 'cur']) {
      final j = validJson();
      j[key] = (j[key] as String).substring(1);
      expect(SavedGame.tryFromJson(j), isNull, reason: key);
    }
    final j = validJson();
    j['notes'] = (j['notes'] as List).sublist(1);
    expect(SavedGame.tryFromJson(j), isNull);
  });

  test('숫자가 범위를 벗어나면 null', () {
    final j = validJson();
    j['sol'] = replaceAt(j['sol'] as String, 5, '0');
    expect(SavedGame.tryFromJson(j), isNull);

    final k = validJson();
    k['cur'] = replaceAt(k['cur'] as String, 5, 'a');
    expect(SavedGame.tryFromJson(k), isNull);

    final n = validJson();
    (n['notes'] as List)[3] = 1024;
    expect(SavedGame.tryFromJson(n), isNull);
  });

  test('난이도 이름 오류면 null', () {
    expect(SavedGame.tryFromJson(validJson()..['d'] = 'nightmare'), isNull);
  });

  test('init 의 0 이 아닌 칸이 sol 과 다르면 null', () {
    final j = validJson();
    // 40번 칸은 given
    j['init'] = replaceAt(j['init'] as String, 40, '${wrongAt(40)}');
    expect(SavedGame.tryFromJson(j), isNull);
  });

  test('cur 의 given 칸이 init 과 다르면 null', () {
    final j = validJson();
    j['cur'] = replaceAt(j['cur'] as String, 40, '${wrongAt(40)}');
    expect(SavedGame.tryFromJson(j), isNull);
  });

  test('wk·hints 왕복', () {
    final j = validJson()
      ..['wk'] = '2026-W44_hard_g1'
      ..['hints'] = 2;
    final s = SavedGame.tryFromJson(j)!;
    expect(s.weeklyBoard, '2026-W44_hard_g1');
    expect(s.hintsUsed, 2);
    final back = s.toJson();
    expect(back['wk'], '2026-W44_hard_g1');
    expect(back['hints'], 2);
    expect(back['v'], 1);
  });

  test('wk·hints 가 없는 기존 JSON 은 일반 판, 힌트 0', () {
    final j = validJson()
      ..remove('wk')
      ..remove('hints');
    final s = SavedGame.tryFromJson(j)!;
    expect(s.weeklyBoard, isNull);
    expect(s.hintsUsed, 0);
    expect(s.toJson().containsKey('wk'), isFalse);
    expect(s.toJson()['hints'], 0);
  });

  test('잘못된 wk 나 음수 hints 면 null', () {
    expect(SavedGame.tryFromJson(validJson()..['wk'] = '2026-44_hard'), isNull);
    expect(SavedGame.tryFromJson(validJson()..['wk'] = 3), isNull);
    expect(SavedGame.tryFromJson(validJson()..['hints'] = -1), isNull);
  });
}
