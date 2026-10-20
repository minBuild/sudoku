import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/difficulty.dart';
import '../models/game_record.dart';

class RecordStore {
  static const _key = 'sudoku_jang_records_v1';

  RecordStore(this._prefs);

  final SharedPreferences _prefs;

  /// 깨진 항목은 건너뛰고, 전체가 깨졌으면 빈 목록을 돌려준다.
  Future<List<GameRecord>> loadAll() async {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null || raw.isEmpty) return [];

      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      final records = <GameRecord>[];
      for (final item in decoded) {
        try {
          records.add(GameRecord.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          debugPrint('RecordStore: 깨진 기록 건너뜀 ($e)');
        }
      }
      records.sort((a, b) => b.finishedAt.compareTo(a.finishedAt));
      return records;
    } catch (e) {
      debugPrint('RecordStore: 기록을 읽지 못함 ($e)');
      return [];
    }
  }

  Future<void> add(GameRecord record) async {
    final all = await loadAll();
    all.insert(0, record);
    await _prefs.setString(
      _key,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearAll() async {
    await _prefs.remove(_key);
  }

  /// 해당 난이도의 최고(최단) 기록. 없으면 null.
  Future<Duration?> bestTime(Difficulty d) async {
    int? best;
    for (final r in await loadAll()) {
      if (r.difficulty != d) continue;
      if (best == null || r.elapsedSeconds < best) best = r.elapsedSeconds;
    }
    return best == null ? null : Duration(seconds: best);
  }
}
