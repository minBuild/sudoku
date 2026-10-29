import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../l10n/l10n.dart';
import '../models/game_status.dart';
import '../theme/app_theme.dart';

/// [되돌리기] [지우기] [메모]
class GameToolBar extends StatelessWidget {
  const GameToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SudokuController>();
    final playing = c.status == GameStatus.playing;
    return Row(
      children: [
        Expanded(
          child: _ToolButton(
            icon: Icons.undo_rounded,
            label: context.l10n.undo,
            onPressed: playing && c.canUndo ? c.undo : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToolButton(
            icon: Icons.backspace_outlined,
            label: context.l10n.erase,
            onPressed: playing ? c.erase : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToolButton(
            icon: Icons.edit_outlined,
            label: context.l10n.memo,
            activeLabel: context.l10n.memoOn,
            active: c.noteMode,
            onPressed: playing ? c.toggleNote : null,
          ),
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.active = false,
    this.activeLabel,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool active;

  /// 토글 버튼이면 켜졌을 때의 라벨. null 이면 일반 버튼.
  final String? activeLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final fg = active
        ? Colors.white
        : enabled
        ? AppTheme.text
        : AppTheme.textSecondary.withValues(alpha: 0.5);
    return Semantics(
      button: true,
      toggled: activeLabel != null ? active : null,
      child: Material(
        color: active ? AppTheme.primary : AppTheme.surface,
        shape: StadiumBorder(
          side: BorderSide(color: active ? AppTheme.primary : AppTheme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          enableFeedback: false, // 효과음은 GameFeedback 이 낸다
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20, color: fg),
                    const SizedBox(height: 2),
                    Text(
                      active ? activeLabel ?? label : label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
