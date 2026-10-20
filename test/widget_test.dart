import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/l10n/strings.dart';
import 'package:sudoku/models/difficulty.dart';

import 'fakes.dart';

void main() {
  testWidgets('홈에 [새 게임] 버튼과 광고 제거 카드가 있다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs)));
    await tester.pump();

    expect(find.text(S.newGame), findsOneWidget);
    expect(find.byKey(const ValueKey('remove-ads-card')), findsOneWidget);
  });

  testWidgets('권리가 있으면 광고 제거 카드가 없다', (tester) async {
    SharedPreferences.setMockInitialValues({'ent_ads_removed_v1': true});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs)));
    await tester.pump();

    expect(find.text(S.newGame), findsOneWidget);
    expect(find.byKey(const ValueKey('remove-ads-card')), findsNothing);
  });

  testWidgets('새 게임 → 난이도 → 준비 → 게임 화면', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final ads = FakeAds();
    await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs, ads: ads)));
    await tester.pump();

    await tester.tap(find.text(S.newGame));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Difficulty.easy.label));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(ads.showCalls, 1);
    expect(find.text(S.undo), findsOneWidget);
    expect(find.text(S.mistakes(0, 5)), findsOneWidget);

    // 게임 타이머 정리
    await tester.pumpWidget(const SizedBox());
  });
}
