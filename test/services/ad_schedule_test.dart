import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/ads/ad_schedule.dart';

void main() {
  late DateTime t;
  late AdSchedule s;

  setUp(() {
    t = DateTime(2026, 1, 1, 12);
    s = AdSchedule(now: () => t);
  });

  test('새 스케줄은 첫 판부터 광고 대상이다', () {
    expect(s.isDue, isTrue);
    expect(s.tryClaim(), isTrue);
  });

  test('release 전에는 다시 점유할 수 없다', () {
    expect(s.tryClaim(), isTrue);
    expect(s.tryClaim(), isFalse);
  });

  test('shown 뒤 14:59 는 대상 아님, 15:00 은 대상', () {
    s.tryClaim();
    s.release(shown: true);
    t = t.add(const Duration(minutes: 14, seconds: 59));
    expect(s.isDue, isFalse);
    expect(s.tryClaim(), isFalse);
    t = t.add(const Duration(seconds: 1));
    expect(s.isDue, isTrue);
  });

  test('shown 이 아니면 기록하지 않고 다시 점유할 수 있다', () {
    s.tryClaim();
    s.release(shown: false);
    expect(s.isDue, isTrue);
    expect(s.tryClaim(), isTrue);
  });

  test('두 번째 shown 이 기준 시각을 갱신한다', () {
    s.tryClaim();
    s.release(shown: true);
    t = t.add(const Duration(minutes: 15));
    expect(s.tryClaim(), isTrue);
    s.release(shown: true);
    t = t.add(const Duration(minutes: 14, seconds: 59));
    expect(s.isDue, isFalse);
  });

  test('시계가 역행하면 대상이다', () {
    s.tryClaim();
    s.release(shown: true);
    t = t.subtract(const Duration(minutes: 1));
    expect(s.isDue, isTrue);
  });

  test('markShown 직후 tryClaim 은 false (보상형 광고 뒤 전면광고 연속 방지)', () {
    s.markShown();
    expect(s.tryClaim(), isFalse);
    t = t.add(AdSchedule.defaultInterval);
    expect(s.tryClaim(), isTrue);
  });

  test('기본 간격은 15분', () {
    expect(AdSchedule.defaultInterval, const Duration(minutes: 15));
    expect(s.interval, AdSchedule.defaultInterval);
  });
}
