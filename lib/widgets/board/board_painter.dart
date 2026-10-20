import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../controllers/sudoku_controller.dart';
import '../../l10n/strings.dart';
import '../../theme/app_theme.dart';
import '../../theme/sudoku_colors.dart';

enum _Kind { given, user, wrong, conflict, note }

/// 칸 크기가 같으면 숫자 TextPainter 를 재사용한다.
class BoardTextCache {
  double _cell = -1;
  final _cache = <(_Kind, int), TextPainter>{};

  TextPainter _get(_Kind kind, int n, double cell, SudokuColors colors) {
    if (cell != _cell) {
      clear();
      _cell = cell;
    }
    return _cache.putIfAbsent((kind, n), () {
      final note = kind == _Kind.note;
      final style = TextStyle(
        fontSize: note ? cell * 0.26 : cell * 0.55,
        height: 1.0,
        fontFeatures: AppTheme.tabular,
        fontWeight: switch (kind) {
          _Kind.given => FontWeight.w600,
          _Kind.note => FontWeight.w500,
          _ => FontWeight.w500,
        },
        color: switch (kind) {
          _Kind.given => colors.given,
          _Kind.user => colors.user,
          _Kind.wrong || _Kind.conflict => colors.error,
          _Kind.note => colors.note,
        },
        decoration: kind == _Kind.wrong ? TextDecoration.underline : null,
        decorationColor: colors.error,
        decorationThickness: 2,
      );
      return TextPainter(
        text: TextSpan(text: '$n', style: style),
        textDirection: TextDirection.ltr,
      )..layout();
    });
  }

  void clear() {
    for (final p in _cache.values) {
      p.dispose();
    }
    _cache.clear();
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter({
    required this.c,
    required this.revision,
    required this.colors,
    required this.cache,
  });

  final SudokuController c;
  final int revision;
  final SudokuColors colors;
  final BoardTextCache cache;

  static const radius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 9;
    final outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );

    // 1. 배경
    canvas.drawRRect(outer, Paint()..color = colors.boardBg);
    canvas.save();
    canvas.clipRRect(outer);

    // 2. 칸 배경
    final sel = c.selected;
    final selValue = sel == null ? 0 : c.valueAt(sel);
    final peers = sel == null
        ? const <int>{}
        : SudokuController.peersOf[sel].toSet();
    final paint = Paint();
    for (var i = 0; i < 81; i++) {
      final rect = Rect.fromLTWH(i % 9 * cell, i ~/ 9 * cell, cell, cell);
      Color? fill;
      if (peers.contains(i)) fill = colors.peer;
      if (selValue != 0 && c.valueAt(i) == selValue) fill = colors.sameNumber;
      if (i == sel) fill = colors.selected;
      if (fill != null) canvas.drawRect(rect, paint..color = fill);
      if (c.isWrongAt(i)) canvas.drawRect(rect, paint..color = colors.errorBg);
    }

    // 3. 격자: 1px 칸선, 2px 박스선
    final thin = Paint()
      ..color = colors.gridThin
      ..strokeWidth = 1;
    final bold = Paint()
      ..color = colors.gridBold
      ..strokeWidth = 2;
    for (var k = 1; k < 9; k++) {
      final d = k * cell;
      final p = k % 3 == 0 ? bold : thin;
      canvas.drawLine(Offset(d, 0), Offset(d, size.height), p);
      canvas.drawLine(Offset(0, d), Offset(size.width, d), p);
    }
    canvas.restore();

    // 4. 테두리
    canvas.drawRRect(
      outer.deflate(1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = colors.gridBold,
    );

    // 5. 숫자, 6. 메모
    for (var i = 0; i < 81; i++) {
      final left = i % 9 * cell, top = i ~/ 9 * cell;
      final v = c.valueAt(i);
      if (v != 0) {
        final kind = c.isGiven(i)
            ? _Kind.given
            : c.isWrongAt(i)
            ? _Kind.wrong
            : (!c.instantCheck && c.isConflictedAt(i))
            ? _Kind.conflict
            : _Kind.user;
        final tp = cache._get(kind, v, cell, colors);
        tp.paint(
          canvas,
          Offset(left + (cell - tp.width) / 2, top + (cell - tp.height) / 2),
        );
        continue;
      }
      final notes = c.notesAt(i);
      if (notes == 0) continue;
      final sub = cell / 3;
      for (var n = 1; n <= 9; n++) {
        if (notes & (1 << (n - 1)) == 0) continue;
        final tp = cache._get(_Kind.note, n, cell, colors);
        final sx = left + (n - 1) % 3 * sub, sy = top + (n - 1) ~/ 3 * sub;
        tp.paint(
          canvas,
          Offset(sx + (sub - tp.width) / 2, sy + (sub - tp.height) / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(BoardPainter oldDelegate) =>
      oldDelegate.revision != revision ||
      oldDelegate.colors != colors ||
      oldDelegate.c != c;

  @override
  SemanticsBuilderCallback get semanticsBuilder => (size) {
    final cell = size.width / 9;
    return [
      for (var i = 0; i < 81; i++)
        CustomPainterSemantics(
          key: ValueKey('cell$i'),
          rect: Rect.fromLTWH(i % 9 * cell, i ~/ 9 * cell, cell, cell),
          properties: SemanticsProperties(
            label: S.cell(i ~/ 9 + 1, i % 9 + 1, c.valueAt(i)),
            selected: c.selected == i,
            textDirection: TextDirection.ltr,
          ),
        ),
    ];
  };

  @override
  bool shouldRebuildSemantics(BoardPainter oldDelegate) =>
      oldDelegate.revision != revision;
}
