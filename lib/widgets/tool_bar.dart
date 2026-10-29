import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../l10n/l10n.dart';
import '../models/game_status.dart';
import '../theme/app_theme.dart';

/// 힌트 버튼의 모양. 남은 무료 횟수 · 광고 필요 · 무제한(광고 제거) · 숨김.
sealed class HintButtonState {
  const HintButtonState();

  const factory HintButtonState.free(int n) = HintFree;
  const factory HintButtonState.needAd() = HintNeedAd;
  const factory HintButtonState.unlimited() = HintUnlimited;
  const factory HintButtonState.hidden() = HintHidden;
}

final class HintFree extends HintButtonState {
  const HintFree(this.n);
  final int n;
}

final class HintNeedAd extends HintButtonState {
  const HintNeedAd();
}

final class HintUnlimited extends HintButtonState {
  const HintUnlimited();
}

final class HintHidden extends HintButtonState {
  const HintHidden();
}

/// [되돌리기] [지우기] [메모] [힌트]. [onHint] 가 null 이면 힌트 버튼 없이 3개.
class GameToolBar extends StatelessWidget {
  const GameToolBar({
    super.key,
    this.onHint,
    this.hintState = const HintButtonState.hidden(),
  });

  final VoidCallback? onHint;
  final HintButtonState hintState;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SudokuController>();
    final playing = c.status == GameStatus.playing;
    final showHint = onHint != null && hintState is! HintHidden;
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
        if (showHint) ...[
          const SizedBox(width: 8),
          Expanded(
            child: _ToolButton(
              icon: hintState is HintNeedAd
                  ? Icons.ondemand_video_outlined
                  : Icons.lightbulb_outline,
              label: context.l10n.hint,
              badge: playing
                  ? switch (hintState) {
                      HintFree(:final n) => n,
                      _ => null,
                    }
                  : null,
              onPressed: playing ? onHint : null,
            ),
          ),
        ],
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
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool active;

  /// 토글 버튼이면 켜졌을 때의 라벨. null 이면 일반 버튼.
  final String? activeLabel;

  /// 아이콘 위 숫자 배지 (힌트 남은 횟수).
  final int? badge;

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
                    badge == null
                        ? Icon(icon, size: 20, color: fg)
                        : Badge(
                            label: Text('$badge'),
                            backgroundColor: AppTheme.primary,
                            child: Icon(icon, size: 20, color: fg),
                          ),
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
