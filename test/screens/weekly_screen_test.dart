import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/screens/home_screen.dart';
import 'package:sudoku/screens/weekly_screen.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';
import 'package:sudoku/services/weekly/weekly_service.dart';
import 'package:sudoku/services/weekly/weekly_store.dart';

import '../fakes.dart';

final _now = DateTime.utc(2026, 10, 29, 3);
const _hard = WeeklyBoard('2026-W44', Difficulty.hard);

void main() {
  late FakeLeaderboard lb;

  Future<void> open(
    WidgetTester tester, {
    Map<String, Object> prefsInit = const {},
  }) async {
    // 카드 5개가 모두 빌드되도록 화면을 길게 (ListView 는 지연 빌드).
    tester.view
      ..physicalSize = const Size(480, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(prefsInit);
    final prefs = await SharedPreferences.getInstance();
    final svc = WeeklyService(
      WeeklyStore(prefs, now: () => _now),
      lb,
      now: () => _now,
    );
    await tester.pumpWidget(
      SudokuApp(deps: fakeDeps(prefs, weekly: svc, withSaves: true)),
    );
    await tester.pump();
    expect(find.text(l10nEn.weeklyTitle), findsOneWidget); // 홈 카드
    Navigator.of(
      tester.element(find.byType(HomeScreen)),
    ).push(MaterialPageRoute<void>(builder: (_) => WeeklyScreen(service: svc)));
    await tester.pumpAndSettle();
  }

  Finder playButtons(String label) => find.widgetWithText(FilledButton, label);

  setUp(() => lb = FakeLeaderboard());

  testWidgets('빈 보드: 1등 없음, 도전 버튼 5개', (tester) async {
    await open(tester);
    expect(find.text(l10nEn.weeklyNoLeader), findsNWidgets(5));
    expect(playButtons(l10nEn.weeklyChallenge), findsNWidgets(5));
    expect(find.text(l10nEn.weeklyRule), findsOneWidget);
    expect(find.text(l10nEn.weeklyLoadFailed), findsNothing);
  });

  testWidgets('실패 배너가 있어도 도전 버튼은 활성', (tester) async {
    lb.offline = true;
    await open(tester);
    expect(find.text(l10nEn.weeklyLoadFailed), findsOneWidget);
    expect(find.text(l10nEn.retry), findsOneWidget);
    final buttons = tester.widgetList<FilledButton>(
      playButtons(l10nEn.weeklyChallenge),
    );
    expect(buttons.length, 5);
    expect(buttons.every((b) => b.onPressed != null), isTrue);
  });

  testWidgets('내가 1등이면 테두리 1.5 와 닉네임 CTA, 빈 닉네임은 익명', (tester) async {
    lb.seed(_hard.id, 'me', 61234);
    await open(tester);
    expect(find.text(l10nEn.anonymous), findsWidgets);
    expect(find.text('01:01.2'), findsOneWidget);
    expect(find.text(l10nEn.weeklyYouAreFirst), findsOneWidget);
    expect(find.text(l10nEn.nicknameSet), findsNWidgets(2)); // 카드 CTA + 푸터
    final bordered = tester
        .widgetList<Container>(find.byType(Container))
        .where(
          (c) =>
              c.decoration is BoxDecoration &&
              ((c.decoration as BoxDecoration).border as Border?)?.top.width ==
                  1.5,
        );
    expect(bordered.length, 1);
  });

  testWidgets('다른 사람이 1등이면 닉네임, CTA 없음', (tester) async {
    lb.seed(_hard.id, 'other', 50000, '스도쿠왕');
    await open(tester);
    expect(find.text('스도쿠왕'), findsOneWidget);
    expect(find.text(l10nEn.weeklyYouAreFirst), findsNothing);
  });

  testWidgets('진행 중인 주간 세이브가 있으면 continueTitle', (tester) async {
    final c = SudokuController.fresh(
      puzzleWithHoles([0, 1]),
      Difficulty.hard,
      instantCheck: true,
      weeklyBoard: _hard.id,
    );
    final save = jsonEncode(c.snapshot().toJson());
    c.dispose();
    await open(tester, prefsInit: {'sudoku_jang_save_v1': save});
    expect(playButtons(l10nEn.continueTitle), findsOneWidget);
    expect(find.text(l10nEn.weeklyInProgress), findsOneWidget);
    expect(playButtons(l10nEn.weeklyChallenge), findsNWidgets(4));
  });
}
