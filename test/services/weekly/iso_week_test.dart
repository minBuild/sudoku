import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/services/sudoku_generator.dart';
import 'package:sudoku/services/weekly/iso_week.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';

// 시간대 규칙: DateTime.utc(...) 나 오프셋을 명시한 DateTime.parse 만 쓴다.
// 로컬 DateTime(...) 생성자는 머신 시간대에 따라 결과가 달라진다.
void main() {
  test('ISO 주차: 연말·연초 경계', () {
    expect(isoWeekKey(DateTime.utc(2026, 1, 1)), '2026-W01');
    expect(isoWeekKey(DateTime.utc(2027, 1, 1)), '2026-W53');
    expect(isoWeekKey(DateTime.utc(2024, 12, 30)), '2025-W01');
    expect(isoWeekKey(DateTime.utc(2021, 1, 3)), '2020-W53');
    expect(isoWeekKey(DateTime.utc(2026, 10, 29)), '2026-W44');
  });

  test('주 경계는 UTC 월요일 00:00', () {
    expect(isoWeekKey(DateTime.utc(2026, 11, 1, 23, 59, 59)), '2026-W44');
    expect(isoWeekKey(DateTime.utc(2026, 11, 2)), '2026-W45');
  });

  test('같은 순간을 다른 시간대로 표현해도 같은 주차', () {
    final before = DateTime.parse('2026-11-02T08:59:59+09:00');
    expect(before, DateTime.utc(2026, 11, 1, 23, 59, 59));
    expect(isoWeekKey(before), '2026-W44');
    expect(isoWeekKey(DateTime.parse('2026-11-02T09:00:00+09:00')), '2026-W45');
    expect(isoWeekKey(DateTime.parse('2026-11-01T19:00:00-05:00')), '2026-W45');
  });

  test('nextWeekStartUtc 는 다음 월요일 00:00Z', () {
    final n = nextWeekStartUtc(DateTime.utc(2026, 10, 29, 15));
    expect(n.isUtc, isTrue);
    expect(n, DateTime.utc(2026, 11, 2));
    // 월요일 00:00 정각이면 그다음 주.
    expect(
      nextWeekStartUtc(DateTime.utc(2026, 11, 2)),
      DateTime.utc(2026, 11, 9),
    );
    expect(
      nextWeekStartUtc(DateTime.parse('2026-11-02T08:59:59+09:00')),
      DateTime.utc(2026, 11, 2),
    );
  });

  test('weekEndUtc·isoWeekNumber', () {
    expect(weekEndUtc('2026-W44'), DateTime.utc(2026, 11, 2));
    expect(weekEndUtc('2026-W53'), DateTime.utc(2027, 1, 4));
    expect(weekEndUtc('2025-W01'), DateTime.utc(2025, 1, 6));
    expect(isoWeekNumber('2026-W44'), 44);
    expect(isoWeekNumber('2020-W53'), 53);
    expect(() => isoWeekNumber('2026-44'), throwsFormatException);
  });

  test('weeklySeed: 고정값, 난이도마다 다르다', () {
    // FNV-1a 32bit('2026-W44|hard'), ('2026-W44|easy'). 바뀌면 모든 주간 퍼즐이 바뀐다.
    expect(weeklySeed('2026-W44', Difficulty.hard), _fnv('2026-W44|hard'));
    expect(weeklySeed('2026-W44', Difficulty.hard), 1188419984);
    expect(weeklySeed('2026-W44', Difficulty.easy), 1102445951);
    final all = {for (final d in Difficulty.values) weeklySeed('2026-W44', d)};
    expect(all.length, Difficulty.values.length);
    expect(
      weeklySeed('2026-W45', Difficulty.hard),
      isNot(weeklySeed('2026-W44', Difficulty.hard)),
    );
  });

  group('WeeklyBoard', () {
    test('id·parse·idRe·request', () {
      const b = WeeklyBoard('2026-W44', Difficulty.hard);
      expect(b.id, '2026-W44_hard_g$kGeneratorVersion');
      expect(WeeklyBoard.idRe.hasMatch(b.id), isTrue);
      expect(WeeklyBoard.parse(b.id), b);
      expect(WeeklyBoard.parse('2026-W44_nightmare_g1'), isNull);
      expect(WeeklyBoard.parse('2026-W4_hard_g1'), isNull);
      expect(b.request.seed, b.seed);
      expect(b.request.weekKey, '2026-W44');
      expect(b.request.difficulty, Difficulty.hard);
    });

    test('current 는 이번 주 5개', () {
      final boards = WeeklyBoard.current(DateTime.utc(2026, 10, 29));
      expect(boards.map((b) => b.weekKey).toSet(), {'2026-W44'});
      expect(boards.map((b) => b.difficulty), Difficulty.values);
    });
  });
}

int _fnv(String s) {
  var h = 0x811C9DC5;
  for (final b in s.codeUnits) {
    h = ((h ^ b) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}
