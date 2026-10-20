import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../controllers/sudoku_controller.dart';
import '../models/difficulty.dart';
import '../models/saved_game.dart';
import '../models/sudoku_puzzle.dart';
import '../screens/game_screen.dart';
import '../services/ads/ad_service.dart';

class PrepareResult {
  const PrepareResult(this.puzzle, this.outcome);
  final SudokuPuzzle puzzle;
  final AdOutcome outcome;
}

/// 새 퍼즐 준비: 생성 ∥ 광고.
class GameLauncher {
  GameLauncher({
    required PuzzleFactory generate,
    required AdGateway ads,
    required ValueListenable<bool> adsRemoved,
  }) : _generate = generate,
       _ads = ads,
       _adsRemoved = adsRemoved;

  static const minVisible = Duration(milliseconds: 300);

  final PuzzleFactory _generate;
  final AdGateway _ads;
  final ValueListenable<bool> _adsRemoved;

  /// 생성 ∥ 광고. 둘 다 끝나야 반환한다 (D5).
  /// 생성이 실패하면 광고가 끝난 뒤 [ParallelWaitError] (D6).
  Future<PrepareResult> prepare(Difficulty d) async {
    final sw = Stopwatch()..start();
    final Future<AdOutcome> ad = _adsRemoved.value
        ? Future.value(AdOutcome.skipped)
        : _safeAd();
    final (puzzle, outcome) = await (_generate(d), ad).wait;
    if (outcome != AdOutcome.shown) {
      final rest = minVisible - sw.elapsed;
      if (rest > Duration.zero) await Future<void>.delayed(rest);
    }
    return PrepareResult(puzzle, outcome);
  }

  Future<AdOutcome> _safeAd() {
    try {
      return _ads.showPreGameAd().catchError((_) => AdOutcome.failed);
    } catch (_) {
      return Future.value(AdOutcome.failed);
    }
  }
}

/// GameScreen 에 넘길 판의 출처.
sealed class GameSeed {
  const GameSeed();

  const factory GameSeed.fresh(
    SudokuPuzzle puzzle,
    Difficulty difficulty,
    bool instantCheck,
  ) = FreshSeed;

  const factory GameSeed.saved(SavedGame game) = SavedSeed;

  SudokuController build();
}

final class FreshSeed extends GameSeed {
  const FreshSeed(this.puzzle, this.difficulty, this.instantCheck);
  final SudokuPuzzle puzzle;
  final Difficulty difficulty;
  final bool instantCheck;

  @override
  SudokuController build() =>
      SudokuController.fresh(puzzle, difficulty, instantCheck: instantCheck);
}

final class SavedSeed extends GameSeed {
  const SavedSeed(this.game);
  final SavedGame game;

  @override
  SudokuController build() => SudokuController.fromSave(game);
}

/// 컨트롤러는 게임 화면 라우트에 묶는다 (D7).
Route<void> gameRoute(GameSeed seed) => MaterialPageRoute(
  builder: (_) => ChangeNotifierProvider(
    create: (_) => seed.build(),
    child: const GameScreen(),
  ),
);
