import 'dart:convert';

import '../../models/difficulty.dart';

/// ISO 주차 (`2026-W44`). 경계는 UTC 월요일 00:00 이다.
/// 머신 로컬 시간대에 의존하지 않도록 반드시 UTC 연·월·일로만 계산한다.
String isoWeekKey(DateTime t) {
  final u = t.toUtc();
  final date = DateTime.utc(u.year, u.month, u.day);
  // 그 주의 목요일이 속한 해가 ISO 연도다.
  final thursday = DateTime.utc(
    date.year,
    date.month,
    date.day - (date.weekday - 1) + 3,
  );
  final dayOfYear =
      thursday.difference(DateTime.utc(thursday.year, 1, 1)).inDays + 1;
  final week = 1 + (dayOfYear - 1) ~/ 7;
  return '${thursday.year}-W${week.toString().padLeft(2, '0')}';
}

/// [t] 다음 월요일 00:00 UTC.
DateTime nextWeekStartUtc(DateTime t) {
  final u = t.toUtc();
  return DateTime.utc(u.year, u.month, u.day - (u.weekday - 1) + 7);
}

final _weekKeyRe = RegExp(r'^(\d{4})-W(\d{2})$');

/// 주가 끝나는 시각(다음 월요일 00:00 UTC). TTL 계산용.
DateTime weekEndUtc(String weekKey) {
  final m = _weekKeyRe.firstMatch(weekKey);
  if (m == null) throw FormatException('weekKey 형식 오류', weekKey);
  final year = int.parse(m.group(1)!);
  final week = int.parse(m.group(2)!);
  // 1월 4일이 들어 있는 주가 1주차다.
  final jan4 = DateTime.utc(year, 1, 4);
  return DateTime.utc(year, 1, 4 - (jan4.weekday - 1) + week * 7);
}

/// `2026-W44` → 44.
int isoWeekNumber(String weekKey) {
  final m = _weekKeyRe.firstMatch(weekKey);
  if (m == null) throw FormatException('weekKey 형식 오류', weekKey);
  return int.parse(m.group(2)!);
}

/// `'$weekKey|${d.name}'` 의 UTF-8 바이트에 FNV-1a 32bit.
int weeklySeed(String weekKey, Difficulty d) {
  var h = 0x811C9DC5;
  for (final b in utf8.encode('$weekKey|${d.name}')) {
    h ^= b;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}
