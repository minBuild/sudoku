import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_record.dart';
import 'package:sudoku/services/record_store.dart';

const key = 'sudoku_jang_records_v1';

Future<RecordStore> storeWith(Object? raw) async {
  SharedPreferences.setMockInitialValues(raw == null ? {} : {key: raw});
  return RecordStore(await SharedPreferences.getInstance());
}

Map<String, Object> rec(String d, int sec, {bool? ic}) => {
  'difficulty': d,
  'elapsedSeconds': sec,
  'wrongCount': 1,
  'finishedAt': DateTime(2026, 1, sec % 28 + 1).toIso8601String(),
  'instantCheck': ?ic,
};

void main() {
  test('깨진 JSON 이면 빈 목록', () async {
    final s = await storeWith('{not json');
    expect(await s.loadAll(), isEmpty);
  });

  test('목록이 아니면 빈 목록', () async {
    final s = await storeWith('{"a":1}');
    expect(await s.loadAll(), isEmpty);
  });

  test('깨진 항목만 건너뛴다', () async {
    final s = await storeWith(
      jsonEncode([
        rec('easy', 100),
        {'difficulty': 'nope', 'elapsedSeconds': 1},
        42,
        rec('hard', 200),
      ]),
    );
    final all = await s.loadAll();
    expect(all.length, 2);
  });

  test('구버전 기록은 instantCheck == true', () async {
    final s = await storeWith(jsonEncode([rec('easy', 100)]));
    final all = await s.loadAll();
    expect(all.single.instantCheck, isTrue);
  });

  test('instantCheck false 는 그대로 읽힌다', () async {
    final s = await storeWith(jsonEncode([rec('easy', 100, ic: false)]));
    expect((await s.loadAll()).single.instantCheck, isFalse);
  });

  test('bestTime 은 난이도별 최단 시간', () async {
    final s = await storeWith(
      jsonEncode([rec('easy', 300), rec('easy', 120), rec('hard', 50)]),
    );
    expect(await s.bestTime(Difficulty.easy), const Duration(seconds: 120));
    expect(await s.bestTime(Difficulty.hard), const Duration(seconds: 50));
    expect(await s.bestTime(Difficulty.hell), isNull);
  });

  test('힌트를 쓴 기록은 bestTime 에서 빠진다', () async {
    final s = await storeWith(
      jsonEncode([
        rec('easy', 300),
        {...rec('easy', 60), 'hintsUsed': 2},
      ]),
    );
    expect(await s.bestTime(Difficulty.easy), const Duration(seconds: 300));
    expect((await s.loadAll()).length, 2); // 목록에는 남는다
  });

  test('hintsUsed 가 없는 기존 JSON 은 0, 왕복은 보존', () async {
    final s = await storeWith(jsonEncode([rec('easy', 100)]));
    expect((await s.loadAll()).single.hintsUsed, 0);
    final r = GameRecord(
      difficulty: Difficulty.easy,
      elapsedSeconds: 1,
      wrongCount: 0,
      finishedAt: DateTime(2026),
      hintsUsed: 3,
    );
    expect(GameRecord.fromJson(r.toJson()).hintsUsed, 3);
  });

  test('add 후 loadAll, clearAll', () async {
    final s = await storeWith(null);
    await s.add(
      GameRecord(
        difficulty: Difficulty.normal,
        elapsedSeconds: 77,
        wrongCount: 0,
        finishedAt: DateTime(2026, 3, 1),
        instantCheck: false,
      ),
    );
    final all = await s.loadAll();
    expect(all.single.elapsedSeconds, 77);
    expect(all.single.instantCheck, isFalse);
    await s.clearAll();
    expect(await s.loadAll(), isEmpty);
  });
}
