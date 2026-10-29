import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/services/sudoku_generator.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';
import 'package:sudoku/services/weekly/weekly_puzzle_cache.dart';

import '../../fakes.dart';

const _key = 'weekly_puzzle_v1';

void main() {
  late SharedPreferences prefs;
  late DateTime now;
  late WeeklyPuzzleCache cache;
  late int makes;

  Future<SudokuPuzzle> make() async {
    makes++;
    return puzzleWithHoles([0, 1, 2]);
  }

  Map<String, dynamic> stored() =>
      jsonDecode(prefs.getString(_key)!) as Map<String, dynamic>;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    now = DateTime.utc(2026, 10, 29);
    cache = WeeklyPuzzleCache(prefs, now: () => now);
    makes = 0;
  });

  const w44 = WeeklyBoard('2026-W44', Difficulty.hard);
  const w45 = WeeklyBoard('2026-W45', Difficulty.hard);

  test('처음은 make 1회, 같은 요청은 캐시', () async {
    final a = await cache.getOrCreate(w44.request, make);
    final b = await cache.getOrCreate(w44.request, make);
    expect(makes, 1);
    expect(b.initial, a.initial);
    expect(b.solution, a.solution);
    expect(stored().keys, [w44.id]);
    expect(stored()[w44.id]['wk'], '2026-W44');
  });

  test('주 경계 직전 생성 뒤 다음 주 생성이면 지난 주 항목을 지운다', () async {
    now = DateTime.utc(2026, 11, 1, 23, 59, 59);
    await cache.getOrCreate(w44.request, make);
    now = DateTime.utc(2026, 11, 2, 0, 0, 1);
    await cache.getOrCreate(w45.request, make);
    expect(makes, 2);
    expect(stored().keys, [w45.id]);
  });

  test('지난 주 보드 요청: 있으면 캐시 히트, 없으면 만들고 두 주 모두 남긴다', () async {
    now = DateTime.utc(2026, 11, 1, 12);
    await cache.getOrCreate(w44.request, make);
    now = DateTime.utc(2026, 11, 3);
    await cache.getOrCreate(w44.request, make);
    expect(makes, 1); // 조회가 정리보다 먼저

    await prefs.remove(_key);
    await cache.getOrCreate(w45.request, make);
    await cache.getOrCreate(w44.request, make);
    expect(makes, 3);
    expect(stored().keys.toSet(), {w44.id, w45.id});
  });

  test('seed 가 다르거나 81자가 깨진 항목은 다시 만든다', () async {
    await cache.getOrCreate(w44.request, make);
    final m = stored();
    m[w44.id]['seed'] = 1;
    await prefs.setString(_key, jsonEncode(m));
    await cache.getOrCreate(w44.request, make);
    expect(makes, 2);

    final m2 = stored();
    m2[w44.id]['init'] = 'x' * 81;
    await prefs.setString(_key, jsonEncode(m2));
    await cache.getOrCreate(w44.request, make);
    expect(makes, 3);

    await prefs.setString(_key, '{broken');
    await cache.getOrCreate(w44.request, make);
    expect(makes, 4);
  });

  test('weekKey 가 없는 요청은 캐시를 거치지 않는다', () async {
    await cache.getOrCreate(const PuzzleRequest(Difficulty.easy), make);
    await cache.getOrCreate(const PuzzleRequest(Difficulty.easy), make);
    expect(makes, 2);
    expect(prefs.getString(_key), isNull);
  });
}
