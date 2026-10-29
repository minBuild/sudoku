import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iso_week.dart';
import 'weekly_board.dart';

/// 주간 대결 로컬 상태: 닉네임, 보드별 내 최고 기록, 미전송 대기열 (W8).
class WeeklyStore {
  WeeklyStore(this._prefs, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const _nickKey = 'weekly_nick_v1';
  static const _bestKey = 'weekly_best_v1';
  static const _pendingKey = 'weekly_pending_v1';

  final SharedPreferences _prefs;
  final DateTime Function() _now;

  /// 닉네임·기록이 바뀔 때마다 올라간다. 홈 카드·주간 화면이 듣는다.
  final ValueNotifier<int> changes = ValueNotifier(0);

  // -------------------- 닉네임 --------------------

  String? get nick {
    final n = _prefs.getString(_nickKey);
    return n == null || n.isEmpty ? null : n;
  }

  Future<void> setNick(String nick) async {
    await _safe(_prefs.setString(_nickKey, nick));
    changes.value++;
  }

  // -------------------- 내 기록 --------------------

  int? bestOf(String board) => _readMap(_bestKey)[board];

  /// 최솟값을 남긴다. 현재 주와 직전 주 보드만 보관한다.
  Future<void> recordClear(String board, int ms) {
    final m = _readMap(_bestKey);
    final old = m[board];
    if (old == null || ms < old) m[board] = ms;
    final now = _now();
    final keep = {
      isoWeekKey(now),
      isoWeekKey(now.toUtc().subtract(const Duration(days: 7))),
    };
    m.removeWhere((k, _) => !keep.contains(WeeklyBoard.parse(k)?.weekKey));
    final done = _writeMap(_bestKey, m);
    changes.value++;
    return done;
  }

  /// 그 주에 기록이 있는 보드 수.
  int clearedCount(String weekKey) => _readMap(
    _bestKey,
  ).keys.where((k) => WeeklyBoard.parse(k)?.weekKey == weekKey).length;

  /// 그 주에 기록이 있는 보드 ID.
  Iterable<String> clearedBoards(String weekKey) => _readMap(
    _bestKey,
  ).keys.where((k) => WeeklyBoard.parse(k)?.weekKey == weekKey);

  // -------------------- 대기열 --------------------

  Map<String, int> get pending => _readMap(_pendingKey);

  Future<void> addPending(String board, int ms) {
    final m = _readMap(_pendingKey);
    final old = m[board];
    if (old == null || ms < old) m[board] = ms;
    return _writeMap(_pendingKey, m);
  }

  Future<void> removePending(String board) {
    final m = _readMap(_pendingKey)..remove(board);
    return _writeMap(_pendingKey, m);
  }

  // -------------------- 내부 --------------------

  Map<String, int> _readMap(String key) {
    try {
      final raw = _prefs.getString(key);
      if (raw == null) return {};
      final m = jsonDecode(raw);
      if (m is! Map) return {};
      return {
        for (final e in m.entries)
          if (e.key is String && e.value is int)
            e.key as String: e.value as int,
      };
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeMap(String key, Map<String, int> m) =>
      _safe(_prefs.setString(key, jsonEncode(m)));

  static Future<void> _safe(Future<bool> f) async {
    try {
      await f;
    } catch (e) {
      debugPrint('WeeklyStore: 저장 실패 ($e)');
    }
  }
}
