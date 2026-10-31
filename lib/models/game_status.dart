enum GameStatus { playing, paused, solved, failed }

extension GameStatusX on GameStatus {
  bool get isOver => this == GameStatus.solved || this == GameStatus.failed;
}

/// 컨트롤러가 알리는 "실제로 일어난 일". 소리·햅틱·흔들림은 구독자가 정한다.
enum GameEffect {
  selected,

  /// 모드 전환·지우기·되돌리기처럼 판이 바뀌었지만 숫자를 적지는 않은 입력.
  accepted,

  /// 숫자를 칸에 적었다 (즉시 확인 꺼짐·충돌 없음·정답 포함).
  placed,

  /// 메모 숫자를 켜거나 꺼서 메모가 바뀌었다.
  noted,
  wrong,
  conflict,
  firstMistake,
  solved,
  failed,
  hinted,
}
