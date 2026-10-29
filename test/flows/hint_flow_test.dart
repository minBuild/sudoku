import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/flows/game_launcher.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_status.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/screens/game_screen.dart';
import 'package:sudoku/screens/home_screen.dart';
import 'package:sudoku/services/ads/ad_service.dart';
import 'package:sudoku/services/hint_budget.dart';

import '../fakes.dart';

final _today = DateTime(2026, 10, 29, 12);

class _Harness {
  _Harness(this.prefs, this.ads, this.budget);
  final SharedPreferences prefs;
  final FakeAds ads;
  final HintBudget budget;
}

Future<_Harness> _start(
  WidgetTester tester, {
  int freeUsed = 0,
  bool adsRemoved = false,
  String? weeklyBoard,
  SudokuPuzzle? puzzle,
}) async {
  SharedPreferences.setMockInitialValues({
    'hint_budget_v1': jsonEncode({'date': '2026-10-29', 'used': freeUsed}),
    if (adsRemoved) 'ent_ads_removed_v1': true,
  });
  final prefs = await SharedPreferences.getInstance();
  final ads = FakeAds();
  final budget = HintBudget(prefs, now: () => _today);
  await tester.pumpWidget(
    SudokuApp(
      deps: fakeDeps(prefs, ads: ads, hintBudget: budget),
    ),
  );
  await tester.pump();
  Navigator.of(tester.element(find.byType(HomeScreen))).push(
    gameRoute(
      GameSeed.fresh(
        puzzle ?? puzzleWithHoles([0, 1, 2, 3, 4, 5]),
        Difficulty.easy,
        true,
        weeklyBoard: weeklyBoard,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return _Harness(prefs, ads, budget);
}

SudokuController _c(WidgetTester tester) =>
    tester.element(find.byType(GameScreen)).read<SudokuController>();

Future<void> _tapHint(WidgetTester tester) async {
  await tester.tap(find.text(l10nEn.hint));
  await tester.pumpAndSettle();
}

Future<void> _watchAd(WidgetTester tester) async {
  expect(find.text(l10nEn.rewardHintTitle), findsOneWidget);
  await tester.tap(find.text(l10nEn.watchAd));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('무료 3회는 즉시 적용되고 consume 된다', (tester) async {
    final h = await _start(tester);
    final c = _c(tester);
    for (var i = 1; i <= 3; i++) {
      await _tapHint(tester);
      expect(c.hintsUsed, i);
      expect(h.budget.freeLeft.value, 3 - i);
    }
    expect(h.ads.rewardCalls, 0);
    expect(find.text(l10nEn.rewardHintTitle), findsNothing);
  });

  testWidgets('무료 0 이면 광고 → earned 면 적용, 무료 횟수는 그대로', (tester) async {
    final h = await _start(tester, freeUsed: 3);
    h.ads.onReward = RewardOutcome.earned;
    final c = _c(tester);
    await _tapHint(tester);
    await _watchAd(tester);
    expect(h.ads.rewardCalls, 1);
    expect(c.hintsUsed, 1);
    expect(h.budget.freeLeft.value, 0);
    expect(c.status, GameStatus.playing);
  });

  for (final (o, msg) in [
    (RewardOutcome.dismissed, l10nEn.adNotCompleted),
    (RewardOutcome.unavailable, l10nEn.adUnavailable),
  ]) {
    testWidgets('${o.name} 이면 적용하지 않고 스낵바', (tester) async {
      final h = await _start(tester, freeUsed: 3);
      h.ads.onReward = o;
      final c = _c(tester);
      await _tapHint(tester);
      await _watchAd(tester);
      expect(c.hintsUsed, 0);
      expect(find.text(msg), findsOneWidget);
      expect(c.status, GameStatus.playing);
    });
  }

  testWidgets('확인 다이얼로그에서 취소하면 광고도 힌트도 없다', (tester) async {
    final h = await _start(tester, freeUsed: 3);
    await _tapHint(tester);
    await tester.tap(find.text(l10nEn.cancel));
    await tester.pumpAndSettle();
    expect(h.ads.rewardCalls, 0);
    expect(_c(tester).hintsUsed, 0);
  });

  testWidgets('광고 제거 사용자는 광고 0회로 무제한', (tester) async {
    final h = await _start(tester, freeUsed: 3, adsRemoved: true);
    final c = _c(tester);
    for (var i = 1; i <= 5; i++) {
      await _tapHint(tester);
    }
    expect(c.hintsUsed, 5);
    expect(h.ads.rewardCalls, 0);
  });

  testWidgets('주간 판 첫 힌트는 경고, 취소하면 적용하지 않는다', (tester) async {
    final h = await _start(tester, weeklyBoard: '2026-W44_easy_g1');
    final c = _c(tester);
    await _tapHint(tester);
    expect(find.text(l10nEn.hintRankingWarn), findsOneWidget);
    await tester.tap(find.text(l10nEn.cancel));
    await tester.pumpAndSettle();
    expect(c.hintsUsed, 0);
    expect(h.budget.freeLeft.value, 3);

    await _tapHint(tester);
    await tester.tap(find.text(l10nEn.hintUse));
    await tester.pumpAndSettle();
    expect(c.hintsUsed, 1);
    expect(find.text(l10nEn.rankingExcluded), findsOneWidget);

    await _tapHint(tester); // 두 번째부터는 묻지 않는다
    expect(find.text(l10nEn.hintRankingWarn), findsNothing);
    expect(c.hintsUsed, 2);
  });

  testWidgets('광고 중에는 paused, 끝나면 playing', (tester) async {
    final h = await _start(tester, freeUsed: 3);
    final c = _c(tester);
    GameStatus? during;
    h.ads
      ..onReward = RewardOutcome.earned
      ..duringReward = () => during = c.status;
    await _tapHint(tester);
    await _watchAd(tester);
    expect(during, GameStatus.paused);
    expect(c.status, GameStatus.playing);
  });

  testWidgets('재개 지연 경로: 광고 중 hidden 이면 힌트는 적용되고 paused, 복귀하면 playing', (
    tester,
  ) async {
    final h = await _start(tester, freeUsed: 3);
    final c = _c(tester);
    h.ads
      ..onReward = RewardOutcome.earned
      ..duringReward = () {
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      };
    await _tapHint(tester);
    await _watchAd(tester);
    expect(c.hintsUsed, 1);
    expect(c.status, GameStatus.paused);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(c.status, GameStatus.playing);
  });

  testWidgets('채울 칸이 없으면 소비하지 않는다', (tester) async {
    final h = await _start(tester, puzzle: puzzleWithHoles([]));
    await _tapHint(tester);
    expect(_c(tester).hintsUsed, 0);
    expect(h.budget.freeLeft.value, 3);
    expect(h.ads.rewardCalls, 0);
  });
}
