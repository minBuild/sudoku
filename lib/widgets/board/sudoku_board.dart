import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/sudoku_controller.dart';
import '../../theme/app_theme.dart';
import '../../theme/sudoku_colors.dart';
import 'board_painter.dart';

/// CustomPainter 한 장으로 그리는 9×9 보드.
class SudokuBoard extends StatefulWidget {
  const SudokuBoard({super.key});

  @override
  State<SudokuBoard> createState() => SudokuBoardState();
}

class SudokuBoardState extends State<SudokuBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  );
  final _cache = BoardTextCache();

  /// 오답·충돌 시 좌우로 흔든다.
  void shake() => _shake.forward(from: 0);

  @override
  void dispose() {
    _shake.dispose();
    _cache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SudokuController>();
    final colors = SudokuColors.of(context);
    return _buildBoard(c, colors);
  }

  Widget _buildBoard(SudokuController c, SudokuColors colors) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final t = _shake.value;
        final dx = math.sin(t * math.pi * 6) * 8 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BoardPainter.radius),
            boxShadow: AppTheme.cardShadow,
          ),
          child: LayoutBuilder(
            builder: (context, box) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) {
                final cell = box.maxWidth / 9;
                final col = (d.localPosition.dx / cell).floor().clamp(0, 8);
                final row = (d.localPosition.dy / cell).floor().clamp(0, 8);
                c.select(row * 9 + col);
              },
              child: CustomPaint(
                size: Size.square(box.maxWidth),
                painter: BoardPainter(
                  c: c,
                  revision: c.revision,
                  colors: colors,
                  cache: _cache,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
