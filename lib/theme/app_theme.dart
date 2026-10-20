import 'package:flutter/material.dart';

import 'sudoku_colors.dart';

/// 앱 공통 토큰과 라이트 테마. 다크 테마는 범위 밖.
abstract final class AppTheme {
  static const bg = Color(0xFFF5F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF3B5BDB);
  static const primaryPressed = Color(0xFF2F49B0);
  static const primaryTint = Color(0xFFEDF2FF);
  static const primaryTintPressed = Color(0xFFDBE4FF);
  static const text = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const error = Color(0xFFE5484D);
  static const warning = Color(0xFFF59F00);
  static const scrim = Color(0x4D0F172A);

  static const maxContentWidth = 480.0;
  static const pagePadding = 20.0;
  static const cardRadius = 16.0;
  static const buttonRadius = 14.0;

  static const tabular = [FontFeature.tabularFigures()];

  static const cardShadow = [
    BoxShadow(color: Color(0x081F2937), offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(
      color: Color(0x0F3B5BDB),
      offset: Offset(0, 10),
      blurRadius: 24,
      spreadRadius: -4,
    ),
  ];

  static BoxDecoration card({Color color = surface}) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(cardRadius),
    boxShadow: cardShadow,
  );

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primaryTint,
      onPrimaryContainer: primary,
      secondary: primary,
      onSecondary: Colors.white,
      secondaryContainer: primaryTint,
      onSecondaryContainer: primary,
      tertiary: warning,
      onTertiary: Colors.white,
      error: error,
      onError: Colors.white,
      errorContainer: Color(0xFFFDE8E8),
      onErrorContainer: error,
      surface: surface,
      onSurface: text,
      onSurfaceVariant: textSecondary,
      surfaceContainerLowest: surface,
      surfaceContainerLow: bg,
      surfaceContainer: bg,
      surfaceContainerHigh: Color(0xFFEEF0F5),
      surfaceContainerHighest: Color(0xFFE8EAF0),
      outline: border,
      outlineVariant: border,
      shadow: Color(0xFF1F2937),
      scrim: scrim,
      inverseSurface: text,
      onInverseSurface: Colors.white,
      inversePrimary: primaryTintPressed,
    );

    const textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: text,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: text,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: text,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: text),
      bodyMedium: TextStyle(fontSize: 14, color: text),
      bodySmall: TextStyle(fontSize: 12, color: textSecondary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(buttonRadius),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      extensions: [SudokuColors.light],
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: buttonShape,
          side: const BorderSide(color: border),
          foregroundColor: text,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(side: BorderSide(color: border)),
        backgroundColor: surface,
        selectedColor: primary,
        labelStyle: textTheme.labelLarge?.copyWith(color: text),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: Colors.white,
        ),
        showCheckmark: false,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: scrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? primary : border,
        ),
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: const DividerThemeData(color: border, space: 1),
    );
  }
}
