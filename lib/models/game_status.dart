enum GameStatus { playing, paused, solved, failed }

extension GameStatusX on GameStatus {
  bool get isOver => this == GameStatus.solved || this == GameStatus.failed;
}

enum GameEffect { wrong, conflict, firstMistake }
