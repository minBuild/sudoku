import 'package:flutter/material.dart';

/// 보드·게임 화면 디자인 토큰.
@immutable
class SudokuColors extends ThemeExtension<SudokuColors> {
  const SudokuColors({
    required this.boardBg,
    required this.gridThin,
    required this.gridBold,
    required this.given,
    required this.user,
    required this.note,
    required this.peer,
    required this.sameNumber,
    required this.selected,
    required this.error,
    required this.errorBg,
    required this.warning,
  });

  final Color boardBg;
  final Color gridThin;
  final Color gridBold;
  final Color given;
  final Color user;
  final Color note;
  final Color peer;
  final Color sameNumber;
  final Color selected;
  final Color error;
  final Color errorBg;
  final Color warning;

  static const _primary = Color(0xFF3B5BDB);
  static const _error = Color(0xFFE5484D);

  static final light = SudokuColors(
    boardBg: const Color(0xFFFFFFFF),
    gridThin: const Color(0xFFE5E7EB),
    gridBold: const Color(0xFF9CA3AF),
    given: const Color(0xFF1F2937),
    user: _primary,
    note: const Color(0xFF6B7280),
    peer: _primary.withValues(alpha: 0.08),
    sameNumber: _primary.withValues(alpha: 0.18),
    selected: _primary.withValues(alpha: 0.28),
    error: _error,
    errorBg: _error.withValues(alpha: 0.14),
    warning: const Color(0xFFF59F00),
  );

  static SudokuColors of(BuildContext context) =>
      Theme.of(context).extension<SudokuColors>() ?? light;

  @override
  SudokuColors copyWith({
    Color? boardBg,
    Color? gridThin,
    Color? gridBold,
    Color? given,
    Color? user,
    Color? note,
    Color? peer,
    Color? sameNumber,
    Color? selected,
    Color? error,
    Color? errorBg,
    Color? warning,
  }) => SudokuColors(
    boardBg: boardBg ?? this.boardBg,
    gridThin: gridThin ?? this.gridThin,
    gridBold: gridBold ?? this.gridBold,
    given: given ?? this.given,
    user: user ?? this.user,
    note: note ?? this.note,
    peer: peer ?? this.peer,
    sameNumber: sameNumber ?? this.sameNumber,
    selected: selected ?? this.selected,
    error: error ?? this.error,
    errorBg: errorBg ?? this.errorBg,
    warning: warning ?? this.warning,
  );

  @override
  SudokuColors lerp(ThemeExtension<SudokuColors>? other, double t) {
    if (other is! SudokuColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SudokuColors(
      boardBg: l(boardBg, other.boardBg),
      gridThin: l(gridThin, other.gridThin),
      gridBold: l(gridBold, other.gridBold),
      given: l(given, other.given),
      user: l(user, other.user),
      note: l(note, other.note),
      peer: l(peer, other.peer),
      sameNumber: l(sameNumber, other.sameNumber),
      selected: l(selected, other.selected),
      error: l(error, other.error),
      errorBg: l(errorBg, other.errorBg),
      warning: l(warning, other.warning),
    );
  }
}
