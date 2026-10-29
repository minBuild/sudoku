import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../l10n/l10n.dart';
import '../models/game_status.dart';
import '../theme/app_theme.dart';

/// 1~9 숫자패드. 숫자 아래 남은 개수(10sp), 다 채운 숫자는 자리만 유지.
class NumberPad extends StatelessWidget {
  const NumberPad({super.key, this.columns = 9});

  /// 9 = 한 줄, 3 = 3×3 (가로 레이아웃).
  final int columns;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SudokuController>();
    final playing = c.status == GameStatus.playing;
    final keys = [
      for (var n = 1; n <= 9; n++)
        _NumberKey(
          n: n,
          left: c.remaining(n),
          enabled: playing,
          noteMode: c.noteMode,
          onPressed: () => c.input(n),
        ),
    ];
    final rows = <Widget>[];
    for (var i = 0; i < 9; i += columns) {
      rows.add(
        Row(
          children: [
            for (final k in keys.sublist(i, i + columns))
              Expanded(
                child: Padding(padding: const EdgeInsets.all(3), child: k),
              ),
          ],
        ),
      );
    }
    // 계산기 관례: RTL 언어에서도 1~9 는 왼쪽→오른쪽.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }
}

class _NumberKey extends StatelessWidget {
  const _NumberKey({
    required this.n,
    required this.left,
    required this.enabled,
    required this.noteMode,
    required this.onPressed,
  });

  final int n;
  final int left;
  final bool enabled;
  final bool noteMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final done = left <= 0;
    final active = enabled && !done;
    return Semantics(
      button: true,
      enabled: active,
      label: context.l10n.remainingLabel(n, left.clamp(0, 9)),
      excludeSemantics: true,
      child: Opacity(
        opacity: done ? 0.4 : 1,
        child: Material(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            enableFeedback: false, // 효과음은 GameFeedback 이 낸다
            onTap: active ? onPressed : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 56, minWidth: 48),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$n',
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                        color: noteMode
                            ? AppTheme.textSecondary
                            : AppTheme.primary,
                        fontFeatures: AppTheme.tabular,
                      ),
                    ),
                    Text(
                      '${left.clamp(0, 9)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                        fontFeatures: AppTheme.tabular,
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
