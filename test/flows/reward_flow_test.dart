import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app_deps.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/flows/reward_flow.dart';
import 'package:sudoku/l10n/app_localizations.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/services/ads/ad_schedule.dart';
import 'package:sudoku/services/ads/ad_service.dart';

import '../fakes.dart';

class _SpySchedule extends AdSchedule {
  int marks = 0;

  @override
  void markShown() {
    marks++;
    super.markShown();
  }
}

void main() {
  late FakeAds ads;
  late _SpySchedule schedule;
  late SudokuController c;
  late List<String> log;
  bool? result;

  Future<void> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    ads = FakeAds();
    schedule = _SpySchedule();
    log = [];
    result = null;
    c = SudokuController.fresh(
      puzzleWithHoles([0, 1]),
      Difficulty.easy,
      instantCheck: true,
    )..resume();
    await tester.pumpWidget(
      Provider<AppDeps>.value(
        value: fakeDeps(prefs, ads: ads, schedule: schedule),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => TextButton(
                onPressed: () async {
                  result = await runRewardFlow(
                    ctx,
                    purpose: RewardPurpose.continueGame,
                    pauseTarget: c,
                    resumeTarget: () {
                      log.add('resume');
                      c.resume();
                    },
                    onEarned: () => log.add('earned'),
                  );
                },
                child: const Text('go'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 컨트롤러 타이머가 위젯 트리 정리 검사 전에 멈추도록 본문 끝에서 부른다.
  void stop() => c.dispose();

  Future<void> start(WidgetTester tester) async {
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.text(l10nEn.rewardContinueBody), findsOneWidget);
    await tester.tap(find.text(l10nEn.watchAd));
  }

  testWidgets('로딩 중 취소를 누르면 cancelPending', (tester) async {
    await pump(tester);
    final gate = Completer<void>();
    ads.duringReward = () => gate.future;
    await start(tester);
    // 확인 다이얼로그가 닫히는 애니메이션이 끝날 때까지 (스피너 때문에 settle 불가).
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(l10nEn.adLoading), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text(l10nEn.adLoading),
          matching: find.byType(AlertDialog),
        ),
        matching: find.text(l10nEn.cancel),
      ),
    );
    expect(ads.cancelCalls, 1);
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text(l10nEn.adLoading), findsNothing);
    expect(result, isFalse);
    expect(log, ['resume']);
    stop();
  });

  testWidgets('earned: onEarned 가 resumeTarget 보다 먼저, markShown', (
    tester,
  ) async {
    await pump(tester);
    ads.onReward = RewardOutcome.earned;
    await start(tester);
    await tester.pumpAndSettle();
    expect(log, ['earned', 'resume']);
    expect(schedule.marks, 1);
    expect(result, isTrue);
    expect(ads.preloadRewardedCalls, 1);
    stop();
  });

  testWidgets('dismissed: onEarned 없음, markShown 은 한다', (tester) async {
    await pump(tester);
    ads.onReward = RewardOutcome.dismissed;
    await start(tester);
    await tester.pumpAndSettle();
    expect(log, ['resume']);
    expect(schedule.marks, 1);
    expect(result, isFalse);
    expect(find.text(l10nEn.adNotCompleted), findsOneWidget);
    stop();
  });

  testWidgets('unavailable: onEarned·markShown 없음', (tester) async {
    await pump(tester);
    ads.onReward = RewardOutcome.unavailable;
    await start(tester);
    await tester.pumpAndSettle();
    expect(log, ['resume']);
    expect(schedule.marks, 0);
    expect(find.text(l10nEn.adUnavailable), findsOneWidget);
    stop();
  });
}
