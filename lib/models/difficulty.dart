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
        return 'Easy 😎';
      case Difficulty.normal:
        return 'Normal 🙂';
      case Difficulty.hard:
        return 'Hard 💪';
      case Difficulty.expert:
        return 'Expert 🎓';
      case Difficulty.hell:
        return 'Hell 😈';
    }
  }
}
