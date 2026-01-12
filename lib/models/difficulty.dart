enum Difficulty {
  easy,
  normal,
  hard,
  expert,
  hell,
}

extension DifficultyLabel on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return '쉬움';
      case Difficulty.normal:
        return '보통';
      case Difficulty.hard:
        return '어려움';
      case Difficulty.expert:
        return '전문가';
      case Difficulty.hell:
        return '헬';
    }
  }
}
