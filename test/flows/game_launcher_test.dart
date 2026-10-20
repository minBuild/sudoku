import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/flows/game_launcher.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/services/ads/ad_service.dart';

import '../fakes.dart';

void main() {
  late FakeAds ads;
  late Completer<SudokuPuzzle> gen;

  GameLauncher launcher({bool removed = false}) => GameLauncher(
    generate: (_) => gen.future,
    ads: ads,
    adsRemoved: ValueNotifier(removed),
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
}
