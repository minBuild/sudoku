import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/flows/game_launcher.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/services/ads/ad_schedule.dart';
import 'package:sudoku/services/ads/ad_service.dart';

import '../fakes.dart';

void main() {
  late FakeAds ads;
  late Completer<SudokuPuzzle> gen;

  GameLauncher launcher({bool removed = false, AdSchedule? schedule}) =>
      GameLauncher(
        generate: (_) => gen.future,
        ads: ads,
        adsRemoved: ValueNotifier(removed),
        schedule: schedule ?? AdSchedule(),
      );

  setUp(() {
    ads = FakeAds();
  });

  test('권리가 있으면 showPreGameAd 를 부르지 않는다', () {
    fakeAsync((fa) {
      gen = Completer<SudokuPuzzle>();
      PrepareResult? r;
      launcher(removed: true).prepare(Difficulty.easy).then((v) => r = v);
      gen.complete(puzzleWithHoles([0]));
      fa.elapse(const Duration(seconds: 1));
      expect(ads.showCalls, 0);
      expect(r?.outcome, AdOutcome.skipped);
    });
  });

  test('skipped 면 최소 300ms 를 기다린다', () {
    fakeAsync((fa) {
      gen = Completer<SudokuPuzzle>();
      ads.onShow = () => Completer()..complete(AdOutcome.skipped);
      PrepareResult? r;
      launcher().prepare(Difficulty.easy).then((v) => r = v);
      gen.complete(puzzleWithHoles([0]));
      fa.flushMicrotasks();
      fa.elapse(const Duration(milliseconds: 250));
      expect(r, isNull);
      fa.elapse(const Duration(milliseconds: 100));
      expect(r, isNotNull);
      expect(r!.outcome, AdOutcome.skipped);
    });
  });

  test('shown 이면 지연 없이 진행한다', () {
    fakeAsync((fa) {
      gen = Completer<SudokuPuzzle>();
      final ad = Completer<AdOutcome>();
      ads.onShow = () => ad;
      PrepareResult? r;
      launcher().prepare(Difficulty.easy).then((v) => r = v);
      gen.complete(puzzleWithHoles([0]));
      fa.flushMicrotasks();
      expect(r, isNull); // 광고가 끝나기 전에는 진행하지 않는다
      ad.complete(AdOutcome.shown);
      fa.flushMicrotasks();
      expect(r?.outcome, AdOutcome.shown);
    });
  });

  test('광고 중 생성 실패 → 광고가 끝난 뒤 ParallelWaitError', () {
    fakeAsync((fa) {
      gen = Completer<SudokuPuzzle>();
      final ad = Completer<AdOutcome>();
      ads.onShow = () => ad;
      Object? error;
      var done = false;
      launcher()
          .prepare(Difficulty.easy)
          .then<void>(
            (_) => done = true,
            onError: (Object e) {
              error = e;
              done = true;
            },
          );
      gen.completeError(StateError('boom'));
      fa.elapse(const Duration(seconds: 10));
      expect(done, isFalse);

      ad.complete(AdOutcome.shown);
      fa.flushMicrotasks();
      expect(done, isTrue);
      expect(error, isA<ParallelWaitError>());
    });
  });

  test('showPreGameAd 가 throw 해도 생성이 성공하면 정상 결과', () {
    fakeAsync((fa) {
      gen = Completer<SudokuPuzzle>();
      ads.throwOnShow = Exception('ad crash');
      PrepareResult? r;
      launcher().prepare(Difficulty.easy).then((v) => r = v);
      gen.complete(puzzleWithHoles([0]));
      fa.elapse(const Duration(seconds: 1));
      expect(r?.outcome, AdOutcome.failed);
      expect(r?.puzzle, isNotNull);
    });
  });

  group('AdSchedule 간격', () {
    AdSchedule clocked(FakeAsync fa) {
      final base = DateTime(2026);
      return AdSchedule(now: () => base.add(fa.elapsed));
    }

    /// 생성은 즉시 성공, 광고는 [ads.onShow] 대로. 결과를 돌려준다.
    PrepareResult? run(FakeAsync fa, AdSchedule s, {bool removed = false}) {
      gen = Completer<SudokuPuzzle>()..complete(puzzleWithHoles([0]));
      PrepareResult? r;
      launcher(
        removed: removed,
        schedule: s,
      ).prepare(Difficulty.easy).then((v) => r = v);
      fa.elapse(const Duration(seconds: 1));
      return r;
    }

    test('shown 뒤 15분 안의 새 게임은 광고 없이, 15분 뒤에는 광고', () {
      fakeAsync((fa) {
        final s = clocked(fa);
        ads.onShow = () => Completer()..complete(AdOutcome.shown);

        expect(run(fa, s)?.outcome, AdOutcome.shown);
        expect(ads.showCalls, 1);

        final second = run(fa, s);
        expect(ads.showCalls, 1);
        expect(second?.outcome, AdOutcome.skipped);

        fa.elapse(const Duration(minutes: 15));
        expect(run(fa, s)?.outcome, AdOutcome.shown);
        expect(ads.showCalls, 2);
      });
    });

    for (final o in [AdOutcome.skipped, AdOutcome.failed]) {
      test('${o.name} 뒤에는 다음 새 게임에서 다시 시도한다', () {
        fakeAsync((fa) {
          final s = clocked(fa);
          ads.onShow = () => Completer()..complete(o);

          expect(run(fa, s)?.outcome, o);
          expect(s.isDue, isTrue);
          run(fa, s);
          expect(ads.showCalls, 2);
        });
      });
    }

    test('생성 실패여도 광고가 shown 이면 시각을 기록한다', () {
      fakeAsync((fa) {
        final s = clocked(fa);
        gen = Completer<SudokuPuzzle>();
        final ad = Completer<AdOutcome>();
        ads.onShow = () => ad;
        Object? error;
        launcher(schedule: s)
            .prepare(Difficulty.easy)
            .then<void>((_) {}, onError: (Object e) => error = e);
        gen.completeError(StateError('boom'));
        ad.complete(AdOutcome.shown);
        fa.flushMicrotasks();
        expect(error, isA<ParallelWaitError>());
        expect(s.isDue, isFalse);
      });
    });

    test('같은 스케줄로 동시에 prepare 하면 광고는 한 번', () {
      fakeAsync((fa) {
        final s = clocked(fa);
        gen = Completer<SudokuPuzzle>();
        final ad = Completer<AdOutcome>();
        ads.onShow = () => ad;
        PrepareResult? a;
        PrepareResult? b;
        launcher(schedule: s).prepare(Difficulty.easy).then((v) => a = v);
        launcher(schedule: s).prepare(Difficulty.easy).then((v) => b = v);
        gen.complete(puzzleWithHoles([0]));
        fa.elapse(const Duration(seconds: 1));
        expect(ads.showCalls, 1);
        expect(b?.outcome, AdOutcome.skipped);

        ad.complete(AdOutcome.shown);
        fa.flushMicrotasks();
        expect(a?.outcome, AdOutcome.shown);
      });
    });

    test('광고 제거 상태는 스케줄을 건드리지 않는다', () {
      fakeAsync((fa) {
        final s = clocked(fa);
        ads.onShow = () => Completer()..complete(AdOutcome.shown);

        expect(run(fa, s, removed: true)?.outcome, AdOutcome.skipped);
        expect(ads.showCalls, 0);
        expect(s.isDue, isTrue);

        expect(run(fa, s)?.outcome, AdOutcome.shown);
        expect(ads.showCalls, 1);
      });
    });
  });
}
