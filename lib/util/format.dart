import 'package:intl/intl.dart';

/// mm:ss (1시간 이상이면 h:mm:ss).
String formatClock(int totalSeconds) {
  final h = totalSeconds ~/ 3600;
  final m = (totalSeconds % 3600) ~/ 60;
  final s = totalSeconds % 60;
  String two(int v) => v.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

/// mm:ss.s (1시간 이상이면 h:mm:ss.s). 0.1초 아래는 버린다. 주간 기록 표시용.
String formatClockTenths(int ms) =>
    '${formatClock(ms ~/ 1000)}.${ms % 1000 ~/ 100}';

/// 주간 마감 시각을 기기 시간대로. 예: `11/2 (월) 오전 9:00`.
String formatWeekEnd(DateTime t, String locale) =>
    DateFormat.MEd(locale).add_jm().format(t.toLocal());
