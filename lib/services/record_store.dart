import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_record.dart';

class RecordStore {
  static const _key = 'sudoku_jang_records_v1';

  Future<List<GameRecord>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final decoded = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final records = decoded.map(GameRecord.fromJson).toList();

    records.sort((a, b) => b.finishedAt.compareTo(a.finishedAt));
    return records;
  }

  Future<void> add(GameRecord record) async {
    final all = await loadAll();
    all.insert(0, record);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
