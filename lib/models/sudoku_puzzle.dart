class SudokuPuzzle {
  /// 9x9 초기 보드 (0은 비어있는 칸)
  final List<List<int>> initial;

  /// 9x9 정답 보드
  final List<List<int>> solution;

  SudokuPuzzle({required this.initial, required this.solution});
}
