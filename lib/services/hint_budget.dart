import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 하루 무료 힌트. 로컬 날짜가 바뀌면 다시 [dailyFree] 개로 채운다.
class HintBudget {
  HintBudget(this._prefs, {DateTime Function()? now})
    : _now = now ?? DateTime.now {
    refresh();
  }

  static const dailyFree = 3;
  static const _key = 'hint_budget_v1';

  final SharedPreferences _prefs;
  final DateTime Function() _now;

  /// 오늘 남은 무료 힌트.
  final ValueNotifier<int> freeLeft = ValueNotifier(dailyFree);

  /// 저장된 날짜가 오늘과 다르면(미래 날짜 포함) [dailyFree]. 깨져 있어도 [dailyFree].
  void refresh() {
    final (date, used) = _read();
    freeLeft.value = date == _today() ? max(0, dailyFree - used) : dailyFree;
  }

  Future<void> consume() async {
    refresh();
    if (freeLeft.value == 0) return;
    final (date, used) = _read();
    final today = _today();
    final next = date == today ? used + 1 : 1;
    freeLeft.value = max(0, dailyFree - next);
    try {
      await _prefs.setString(_key, jsonEncode({'date': today, 'used': next}));
    } catch (e) {
      debugPrint('HintBudget: 저장 실패 ($e)');
    }
  }

  String _today() {
    final t = _now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)}';
  }

  (String?, int) _read() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) return (null, 0);
      final m = jsonDecode(raw);
      if (m is! Map) return (null, 0);
      final date = m['date'], used = m['used'];
      if (date is! String || used is! int) return (null, 0);
      return (date, used);
    } catch (_) {
      return (null, 0);
    }
  }
}
