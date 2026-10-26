// 스토어 스크린샷 생성용 통합 테스트.
//
//   SCREENSHOT_DIR=/path/out flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/screenshots_test.dart -d <simulator-udid>
//
// 광고·결제는 가짜(test/fakes.dart)를 주입해 광고/동의 창이 뜨지 않는다.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/controllers/sudoku_controller.dart';
import 'package:sudoku/l10n/app_localizations.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/models/game_record.dart';
import 'package:sudoku/models/saved_game.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/services/game_save_store.dart';
import 'package:sudoku/services/purchase/purchase_service.dart';
import 'package:sudoku/services/record_store.dart';
import 'package:sudoku/services/sudoku_generator.dart';
import 'package:sudoku/widgets/board/sudoku_board.dart';
import 'package:sudoku/widgets/continue_card.dart';

import '../test/fakes.dart';

const _privacy = 'https://minbuild.io/sudoku/privacy';

/// `--dart-define=SHOT_LOCALES=ko` 처럼 일부 로케일만 찍을 수 있다.
const _locales = String.fromEnvironment('SHOT_LOCALES', defaultValue: 'en,ko');

/// 로케일별 스토어 표시 가격 (스토어가 돌려주는 문자열을 흉내낸다).
const _price = {'en': r'$0.49', 'ko': '₩900'};

/// 같은 퍼즐을 두 로케일에 쓴다 (결정적 생성을 위해 1회만 만든다).
final SudokuPuzzle _puzzle = generatePuzzle(Difficulty.normal);

/// 빈칸의 약 45% 를 정답으로 채우고 메모를 몇 개 둔 진행 중 판.
SavedGame _savedGame() {
  final sol = Uint8List(81), init = Uint8List(81), cur = Uint8List(81);
  for (var i = 0; i < 81; i++) {
    sol[i] = _puzzle.solution[i ~/ 9][i % 9];
    init[i] = _puzzle.initial[i ~/ 9][i % 9];
    cur[i] = init[i];
  }
  final holes = [for (var i = 0; i < 81; i++) if (init[i] == 0) i];
  // 고정 패턴으로 골라 두 로케일에서 같은 모양이 나오게 한다.
  for (var k = 0; k < holes.length; k++) {
    if ((k * 7) % 11 < 5) cur[holes[k]] = sol[holes[k]];
  }
  final notes = Uint16List(81);
  final empty = [for (final h in holes) if (cur[h] == 0) h];
  if (empty.length > 2) {
    notes[empty[0]] = (1 << (sol[empty[0]] - 1)) | (1 << (sol[empty[1]] - 1));
    notes[empty[2]] = (1 << (sol[empty[2]] - 1)) | (1 << 4);
  }
  return SavedGame(
    difficulty: Difficulty.normal,
    solution: sol,
    initial: init,
    current: cur,
    notes: notes,
    elapsedMs: 4 * 60 * 1000 + 32 * 1000,
    wrongCount: 0,
    instantCheck: true,
    icEverOff: false,
    savedAt: DateTime.now(),
  );
}

Future<void> _seedRecords(SharedPreferences prefs) async {
  final store = RecordStore(prefs);
  final now = DateTime.now();
  final rows = <(Difficulty, int, int, int)>[
    // (difficulty, elapsedSeconds, wrongCount, daysAgo)
    (Difficulty.easy, 3 * 60 + 48, 0, 0),
    (Difficulty.normal, 7 * 60 + 15, 1, 0),
    (Difficulty.hard, 14 * 60 + 2, 2, 1),
    (Difficulty.normal, 8 * 60 + 41, 0, 2),
    (Difficulty.expert, 23 * 60 + 36, 3, 3),
    (Difficulty.easy, 4 * 60 + 20, 1, 4),
    (Difficulty.hell, 31 * 60 + 9, 4, 6),
  ];
  for (final (d, s, w, days) in rows) {
    await store.add(
      GameRecord(
        difficulty: d,
        elapsedSeconds: s,
        wrongCount: w,
        finishedAt: now.subtract(Duration(days: days, minutes: 17 * days)),
      ),
    );
  }
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// pageBack 은 'Back' 툴팁(영문)만 찾으므로 로케일 무관하게 직접 pop 한다.
  Future<void> back(WidgetTester tester) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pump(const Duration(milliseconds: 300));
    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
    await tester.pump(const Duration(milliseconds: 100));
    await binding.takeScreenshot(name);
  }

  Future<void> run(WidgetTester tester, String lang) async {
    tester.platformDispatcher.localesTestValue = [Locale(lang)];
    final l10n = lookupAppLocalizations(Locale(lang));

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await _seedRecords(prefs);
    await GameSaveStore(prefs).write(_savedGame());

    final deps = fakeDeps(
      prefs,
      purchase: FakePurchase(PurchaseReady(_price[lang]!, 'USD')),
      withSaves: true,
      generate: (d) async => generatePuzzle(d),
      privacyPolicyUri: Uri.parse(_privacy),
    );
    await tester.pumpWidget(SudokuApp(key: ValueKey(lang), deps: deps));
    await tester.pumpAndSettle();

    // 1. 홈 (이어하기 카드 + 광고 제거 카드)
    expect(find.byType(ContinueCard), findsOneWidget);
    await shot(tester, 'home_$lang');

    // 2. 게임 (이어하기 → 진행 중 판, 칸 하나 선택)
    await tester.tap(find.byType(ContinueCard));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 150));
    }
    final board = find.byType(SudokuBoard);
    expect(board, findsOneWidget);
    final c = Provider.of<SudokuController>(
      tester.element(board),
      listen: false,
    );
    // 숫자가 들어간 칸(사용자가 채운 칸 우선) 하나를 선택해 하이라이트를 보인다.
    var pick = -1;
    for (var i = 30; i < 81 && pick < 0; i++) {
      if (!c.isGiven(i) && c.valueAt(i) != 0) pick = i;
    }
    if (pick < 0) pick = 40;
    c.select(pick);
    await tester.pump(const Duration(milliseconds: 200));
    await shot(tester, 'game_$lang');

    // 홈으로
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 150));
    }
    await tester.pumpAndSettle();

    // 3. 기록
    await tester.tap(find.text(l10n.records));
    await tester.pumpAndSettle();
    await shot(tester, 'records_$lang');
    await back(tester);

    // 4. 설정 (광고 제거 섹션)
    await tester.tap(find.text(l10n.settings));
    await tester.pumpAndSettle();
    expect(find.text(l10n.restorePurchases), findsOneWidget);
    await shot(tester, 'settings_$lang');
    await back(tester);
  }

  for (final lang in _locales.split(',')) {
    testWidgets('store screenshots $lang', (tester) async {
      await run(tester, lang);
    });
  }
}
