enum Difficulty { easy, normal, hard, expert, hell }

extension DifficultyRules on Difficulty {
  /// 생성기가 뚫으려고 시도하는 빈칸 수.
  int get targetHoles => switch (this) {
    Difficulty.easy => 38,
    Difficulty.normal => 45,
    Difficulty.hard => 52,
    Difficulty.expert => 58,
    Difficulty.hell => 62,
  };

  /// 수용 기준(최소 빈칸 수). 유일해 조건 때문에 목표에 못 미칠 수 있다.
  int get minAcceptHoles => switch (this) {
    Difficulty.easy => 38,
    Difficulty.normal => 45,
    Difficulty.hard => 48,
    Difficulty.expert => 50,
    Difficulty.hell => 50,
  };
}
