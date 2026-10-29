enum GameStatus { playing, paused, solved, failed }

extension GameStatusX on GameStatus {
  bool get isOver => this == GameStatus.solved || this == GameStatus.failed;
}

/// 컨트롤러가 알리는 "실제로 일어난 일". 소리·햅틱·흔들림은 구독자가 정한다.
enum GameEffect {
  selected,
  accepted,
  wrong,
  conflict,
  firstMistake,
  solved,
  failed,
  hinted,
}
