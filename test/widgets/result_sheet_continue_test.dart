import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/l10n/app_localizations.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/services/purchase/entitlement_store.dart';
import 'package:sudoku/services/purchase/purchase_service.dart';
import 'package:sudoku/services/weekly/weekly_service.dart';
import 'package:sudoku/util/format.dart';
import 'package:sudoku/widgets/result_sheet.dart';

import '../fakes.dart';

void main() {
  late List<ResultAction?> popped;

  Future<void> pump(
    WidgetTester tester, {
    bool solved = false,
    bool weekly = false,
    ValueNotifier<WeeklySubmitState>? state,
    Future<bool> Function()? onContinue,
    Future<void> Function(BuildContext)? onSetNickname,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    popped = [];
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<EntitlementStore>.value(value: EntitlementStore(prefs)),
          Provider<PurchaseGateway>.value(value: FakePurchase()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => TextButton(
                onPressed: () async {
                  popped.add(
                    await ResultSheet.show(
                      ctx,
                      solved: solved,
                      elapsedSeconds: 65,
                      wrongCount: solved ? 0 : 5,
                      difficulty: Difficulty.hard,
                      isNewBest: false,
                      elapsedMs: 65432,
                      weekly: weekly,
                      weeklyState: state,
                      onContinue: onContinue,
                      onSetNickname: onSetNickname,
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('onContinue 가 false 면 시트가 남고 버튼이 다시 활성, true 면 pop', (
    tester,
  ) async {
    var answer = false;
    var calls = 0;
    await pump(
      tester,
      onContinue: () async {
        calls++;
        return answer;
      },
    );
    await tester.tap(find.text(l10nEn.continueWithAd));
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(popped, isEmpty);
    expect(find.text(l10nEn.continueWithAd), findsOneWidget);

    answer = true;
    await tester.tap(find.text(l10nEn.continueWithAd));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(popped, [ResultAction.continueGame]);
  });

  testWidgets('주간 상태 5종 문구', (tester) async {
    final state = ValueNotifier<WeeklySubmitState>(const Sending());
    await pump(tester, solved: true, weekly: true, state: state);
    expect(find.text(l10nEn.weeklySending), findsOneWidget);
    expect(find.text(formatClockTenths(65432)), findsOneWidget); // 01:05.4
    expect(find.text(l10nEn.weeklyRetry), findsOneWidget);

    state.value = const MyBest(61234);
    await tester.pump();
    expect(find.text(l10nEn.weeklyMyBest('01:01.2')), findsOneWidget);

    state.value = const Rank1(61234, needsNick: false);
    await tester.pump();
    expect(find.text(l10nEn.weeklyRank1), findsOneWidget);
    expect(find.text(l10nEn.nicknameSet), findsNothing);

    state.value = const HintExcluded();
    await tester.pump();
    expect(find.text(l10nEn.weeklyHintExcluded), findsOneWidget);

    state.value = const LastWeek();
    await tester.pump();
    expect(find.text(l10nEn.weeklyLastWeek), findsOneWidget);
  });

  testWidgets('Rank1(needsNick) 이면 닉네임 입력을 1회만 자동 호출', (tester) async {
    final state = ValueNotifier<WeeklySubmitState>(const Sending());
    var asked = 0;
    await pump(
      tester,
      solved: true,
      weekly: true,
      state: state,
      onSetNickname: (_) async => asked++,
    );
    expect(asked, 0);
    state.value = const Rank1(61234, needsNick: true);
    await tester.pump();
    expect(asked, 1);
    expect(find.text(l10nEn.nicknameSet), findsOneWidget);
    state.value = const Sending();
    await tester.pump();
    state.value = const Rank1(60000, needsNick: true);
    await tester.pump();
    expect(asked, 1);

    await tester.tap(find.text(l10nEn.nicknameSet)); // 시트 안 버튼은 언제든
    await tester.pump();
    expect(asked, 2);
  });
}
