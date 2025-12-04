class SudokuCell {
  final int row;
  final int col;
  final bool isGiven; // 처음부터 채워진 값인지

  int? value; // 현재 값 (1~9, 없으면 null)
  bool isSelected;
  bool isConflicted; // 중복 등 오류 상태
  bool isHighlighted; // 선택한 기준에 의해 하이라이트 여부
  Set<int> notes; // ✅ 메모(후보 숫자들)

  SudokuCell({
    required this.row,
    required this.col,
    required this.isGiven,
    this.value,
    this.isSelected = false,
    this.isConflicted = false,
    this.isHighlighted = false,
    Set<int>? notes,
  }) : notes = notes ?? {};
}
