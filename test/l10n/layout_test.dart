import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/l10n/difficulty_label.dart';
import 'package:sudoku/l10n/l10n.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_record.dart';
import 'package:sudoku/screens/home_screen.dart';
import 'package:sudoku/screens/prepare_screen.dart';
import 'package:sudoku/screens/weekly_screen.dart';
import 'package:sudoku/services/game_save_store.dart';
import 'package:sudoku/services/record_store.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';
import 'package:sudoku/services/weekly/weekly_service.dart';
import 'package:sudoku/services/weekly/weekly_store.dart';
import 'package:sudoku/widgets/nickname_dialog.dart';
import 'package:sudoku/widgets/weekly_card.dart';
import 'package:sudoku/widgets/continue_card.dart';
import 'package:sudoku/widgets/number_pad.dart';
import 'package:sudoku/widgets/result_sheet.dart';

import '../fakes.dart';

/// 360×640dp 에서 지원 언어 전부 × 화면별 overflow 를 확인한다.
/// 글자 잘림은 Ahem 폰트로 판정할 수 없다. 최종 판정은 실폰트 수동 캡처.
final _privacyUri = Uri.parse('https://example.com/privacy');

/// 320dp 폭에서 따로 도는 긴 문구 대표 언어.
const _narrow = {'de', 'ru', 'pt', 'fr', 'ar'};

Future<AppLocalizations> _pumpApp(
  WidgetTester tester,
  Locale locale, {
  double textScale = 1.0,
  Uri? privacyUri,
  bool withSave = false,
  bool weekly = false,
  Size size = const Size(360, 640),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  tester.platformDispatcher
    ..localesTestValue = [locale]
    ..textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await RecordStore(prefs).add(
    GameRecord(
      difficulty: Difficulty.expert,
      elapsedSeconds: 754,
      wrongCount: 2,
      finishedAt: DateTime(2026, 9, 28),
      instantCheck: false,
    ),
  );
  if (withSave) {
    final c = SudokuController.fresh(
      puzzleWithHoles([0, 1, 2, 10]),
      Difficulty.hard,
      instantCheck: true,
    )..resume();
    c
      ..select(0)
      ..input(solAt(0));
    await GameSaveStore(prefs).write(c.snapshot());
    c.dispose();
  }
  await tester.pumpWidget(
    SudokuApp(
      deps: fakeDeps(
        prefs,
        withSaves: withSave,
        privacyPolicyUri: privacyUri,
        weekly: weekly ? await _weekly(prefs) : null,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return lookupAppLocalizations(locale);
}

Future<void> _enterGame(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(find.text(l.newGame));
  await tester.pumpAndSettle();
  await tester.tap(find.text(Difficulty.easy.label(l)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  expect(find.text(l.undo), findsOneWidget);
}

/// 빈칸 0·1·2 에 정답을 넣어 클리어하고 결과 시트를 띄운다.
Future<void> _clearGame(WidgetTester tester, AppLocalizations l) async {
  await _enterGame(tester, l);
  final c = Provider.of<SudokuController>(
    tester.element(find.byType(NumberPad)),
    listen: false,
  );
  for (final i in [0, 1, 2]) {
    c
      ..select(i)
      ..input(solAt(i));
  }
  await tester.pumpAndSettle();
  expect(find.byType(ResultSheet), findsOneWidget);
}

/// 12자 닉네임으로 1등인 보드 1개, 다른 사람 1등 보드 1개.
Future<WeeklyService> _weekly(SharedPreferences prefs) async {
  final lb = FakeLeaderboard();
  final boards = WeeklyBoard.current(DateTime.now());
  lb.seed(boards[2].id, 'me', 61234, 'Wwwwwwwwwwww');
  lb.seed(boards[4].id, 'other', 3599999, 'Mmmmmmmmmmmm');
  final store = WeeklyStore(prefs);
  await store.setNick('Wwwwwwwwwwww');
  await store.recordClear(boards[2].id, 61234);
  return WeeklyService(store, lb);
}

/// 실수 5회로 게임 오버 시트를 띄운다.
Future<void> _failGame(WidgetTester tester, AppLocalizations l) async {
  await _enterGame(tester, l);
  final c = Provider.of<SudokuController>(
    tester.element(find.byType(NumberPad)),
    listen: false,
  );
  c.select(0);
  for (var k = 0; k < SudokuController.maxWrong; k++) {
    c.input(solAt(k.isEven ? 1 : 2)); // 빈칸 0 에 번갈아 오답
  }
  await tester.pumpAndSettle();
  expect(find.text(l.continueWithAd), findsOneWidget);
}

BuildContext _home(WidgetTester tester) =>
    tester.element(find.byType(HomeScreen, skipOffstage: false));

/// 새 화면들의 overflow 를 확인한다 (W 명세 §3-G layout).
Future<void> _checkWeeklyUi(
  WidgetTester tester,
  Locale locale,
  String tag,
  double scale,
) async {
  // 홈: 이어하기 + 주간 카드
  var l = await _pumpApp(
    tester,
    locale,
    textScale: scale,
    withSave: true,
    weekly: true,
  );
  expect(find.byType(WeeklyCard), findsOneWidget);
  _expectNoOverflow(tester, '$tag 홈 주간 카드 $scale');

  // 주간 화면 (닉네임 12자)
  final svc = await _weekly(await SharedPreferences.getInstance());
  Navigator.of(
    _home(tester),
  ).push(MaterialPageRoute<void>(builder: (_) => WeeklyScreen(service: svc)));
  await tester.pumpAndSettle();
  _expectNoOverflow(tester, '$tag 주간 화면 $scale');
  Navigator.of(_home(tester)).pop();
  await tester.pumpAndSettle();

  // 닉네임 다이얼로그 (에러 상태)
  NicknameDialog.showAndSave(_home(tester), svc);
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), 'a-b');
  await tester.tap(find.text(l.save));
  await tester.pumpAndSettle();
  expect(find.text(l.nicknameInvalid), findsOneWidget);
  _expectNoOverflow(tester, '$tag 닉네임 다이얼로그 $scale');
  await tester.tap(find.text(l.cancel));
  await tester.pumpAndSettle();

  // 주간 결과 시트 (Rank1 + 닉네임 버튼)
  ResultSheet.show(
    _home(tester),
    solved: true,
    elapsedSeconds: 3599,
    wrongCount: 4,
    difficulty: Difficulty.expert,
    isNewBest: false,
    elapsedMs: 3599999,
    weekly: true,
    weeklyState: ValueNotifier(const Rank1(3599999, needsNick: true)),
    onSetNickname: (_) async {},
  );
  await tester.pumpAndSettle();
  expect(find.text(l.weeklyRank1), findsOneWidget);
  _expectNoOverflow(tester, '$tag 주간 결과 시트 $scale');

  // 닫기 버튼이 있는 준비 화면
  l = await _pumpApp(tester, locale, textScale: scale);
  Navigator.of(_home(tester)).push(
    MaterialPageRoute<void>(
      builder: (_) => PrepareScreen(
        difficulty: Difficulty.hell,
        weekly: WeeklyBoard.current(DateTime.now()).last,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  _expectNoOverflow(tester, '$tag 준비 화면 $scale');
  await tester.pumpAndSettle();
  await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리

  // 게임 오버 시트 (이어서 도전)
  l = await _pumpApp(tester, locale, textScale: scale);
  await _failGame(tester, l);
  _expectNoOverflow(tester, '$tag 게임 오버 시트 $scale');
  await tester.pumpWidget(const SizedBox());
}

Future<void> _openSettings(WidgetTester tester, AppLocalizations l) async {
  await tester.tap(find.text(l.settings));
  await tester.pumpAndSettle();
  expect(find.text(l.restorePurchases), findsOneWidget);
  expect(find.text(l.privacyPolicy), findsOneWidget);
}

void _expectNoOverflow(WidgetTester tester, String what) =>
    expect(tester.takeException(), isNull, reason: what);

/// 게임 ⋮ 메뉴(다시 시작·즉시 체크·효과음)를 열어 overflow 를 보고 닫는다.
Future<void> _checkGameMenu(
  WidgetTester tester,
  AppLocalizations l,
  String what,
) async {
  await tester.tap(find.byTooltip(l.more));
  await tester.pumpAndSettle();
  expect(find.text(l.soundEffects), findsOneWidget);
  _expectNoOverflow(tester, what);
  await tester.tapAt(const Offset(4, 4)); // 메뉴 바깥
  await tester.pumpAndSettle();
  expect(find.text(l.soundEffects), findsNothing);
}

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    final tag = locale.toLanguageTag();
    group(tag, () {
      testWidgets('홈', (tester) async {
        await _pumpApp(tester, locale);
        _expectNoOverflow(tester, '$tag 홈');
      });

      testWidgets('홈: 이어하기 카드', (tester) async {
        await _pumpApp(tester, locale, withSave: true);
        expect(find.byType(ContinueCard), findsOneWidget);
        _expectNoOverflow(tester, '$tag 이어하기 카드');
      });

      testWidgets('난이도 시트', (tester) async {
        final l = await _pumpApp(tester, locale);
        await tester.tap(find.text(l.newGame));
        await tester.pumpAndSettle();
        expect(find.text(l.chooseDifficulty), findsOneWidget);
        _expectNoOverflow(tester, '$tag 난이도 시트');
      });

      testWidgets('게임', (tester) async {
        final l = await _pumpApp(tester, locale);
        await _enterGame(tester, l);
        _expectNoOverflow(tester, '$tag 게임');
        await _checkGameMenu(tester, l, '$tag 게임 메뉴');
        await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리
      });

      testWidgets('결과 시트', (tester) async {
        final l = await _pumpApp(tester, locale);
        await _clearGame(tester, l);
        _expectNoOverflow(tester, '$tag 결과 시트');
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('설정', (tester) async {
        final l = await _pumpApp(tester, locale, privacyUri: _privacyUri);
        await _openSettings(tester, l);
        _expectNoOverflow(tester, '$tag 설정');
      });

      testWidgets('기록', (tester) async {
        final l = await _pumpApp(tester, locale);
        await tester.tap(find.text(l.records));
        await tester.pumpAndSettle();
        expect(find.text(l.recentRecords(1)), findsOneWidget);
        _expectNoOverflow(tester, '$tag 기록');
      });

      testWidgets('주간·힌트·이어 도전 화면', (tester) async {
        await _checkWeeklyUi(tester, locale, tag, 1.0);
      });

      testWidgets('글자 1.3배: 주간·힌트·이어 도전 화면', (tester) async {
        await _checkWeeklyUi(tester, locale, tag, 1.3);
      });

      testWidgets('글자 1.3배: 홈', (tester) async {
        await _pumpApp(tester, locale, textScale: 1.3);
        _expectNoOverflow(tester, '$tag 홈 1.3배');
      });

      testWidgets('글자 1.3배: 게임', (tester) async {
        final l = await _pumpApp(tester, locale, textScale: 1.3);
        await _enterGame(tester, l);
        _expectNoOverflow(tester, '$tag 게임 1.3배');
        await _checkGameMenu(tester, l, '$tag 게임 메뉴 1.3배');
        await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리
      });

      if (_narrow.contains(tag)) {
        group('320dp', () {
          const narrow = Size(320, 568);

          testWidgets('홈', (tester) async {
            await _pumpApp(tester, locale, size: narrow);
            _expectNoOverflow(tester, '$tag 320 홈');
          });

          testWidgets('게임', (tester) async {
            final l = await _pumpApp(tester, locale, size: narrow);
            await _enterGame(tester, l);
            _expectNoOverflow(tester, '$tag 320 게임');
            await tester.pumpWidget(const SizedBox());
          });

          testWidgets('결과 시트', (tester) async {
            final l = await _pumpApp(tester, locale, size: narrow);
            await _clearGame(tester, l);
            _expectNoOverflow(tester, '$tag 320 결과 시트');
            await tester.pumpWidget(const SizedBox());
          });

          testWidgets('설정', (tester) async {
            final l = await _pumpApp(
              tester,
              locale,
              size: narrow,
              privacyUri: _privacyUri,
            );
            await _openSettings(tester, l);
            _expectNoOverflow(tester, '$tag 320 설정');
          });
        });
      }
    });
  }
}
