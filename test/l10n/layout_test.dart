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
import 'package:sudoku/services/game_save_store.dart';
import 'package:sudoku/services/record_store.dart';
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
      deps: fakeDeps(prefs, withSaves: withSave, privacyPolicyUri: privacyUri),
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
