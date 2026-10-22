import '../models/difficulty.dart';
import 'app_localizations.dart';

/// 화면에 보이는 난이도 이름. 저장 데이터는 `Difficulty.name` 을 쓴다.
extension DifficultyLabel on Difficulty {
  String label(AppLocalizations l) => switch (this) {
    Difficulty.easy => l.difficultyEasy,
    Difficulty.normal => l.difficultyNormal,
    Difficulty.hard => l.difficultyHard,
    Difficulty.expert => l.difficultyExpert,
    Difficulty.hell => l.difficultyHell,
  };
}
