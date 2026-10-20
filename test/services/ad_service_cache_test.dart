import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/ads/ad_service.dart';

void main() {
  final loadedAt = DateTime(2026, 10, 21, 12);

  test('캐시 TTL 은 50분', () {
    expect(AdMobService.cacheTtl, const Duration(minutes: 50));
  });

  test('49분 59초는 유효, 50분 1초는 만료', () {
    expect(
      AdMobService.isExpired(
        loadedAt,
        loadedAt.add(const Duration(minutes: 49, seconds: 59)),
      ),
      isFalse,
    );
    expect(
      AdMobService.isExpired(
        loadedAt,
        loadedAt.add(const Duration(minutes: 50, seconds: 1)),
      ),
      isTrue,
    );
  });

  test('주입한 시계 기준으로 경계를 넘으면 만료된다', () {
    fakeAsync((async) {
      final clock = async.getClock(loadedAt);
      final start = clock.now();

      async.elapse(const Duration(minutes: 49, seconds: 59));
      expect(AdMobService.isExpired(start, clock.now()), isFalse);

      async.elapse(const Duration(seconds: 1));
      expect(
        AdMobService.isExpired(start, clock.now()),
        isFalse,
        reason: '정확히 50분은 아직 유효',
      );

      async.elapse(const Duration(seconds: 1));
      expect(AdMobService.isExpired(start, clock.now()), isTrue);
    });
  });
}
