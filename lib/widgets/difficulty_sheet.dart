import 'package:flutter/material.dart';

import '../controllers/sudoku_controller.dart';
import '../l10n/l10n.dart';
import '../l10n/difficulty_label.dart';
import '../models/difficulty.dart';
import '../theme/app_theme.dart';

/// 난이도 선택 시트. `pop(ctx, Difficulty)` 로 돌려준다.
class DifficultySheet extends StatelessWidget {
  const DifficultySheet({super.key});

  static Future<Difficulty?> show(BuildContext context) =>
      showModalBottomSheet<Difficulty>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => const DifficultySheet(),
      );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.chooseDifficulty, style: text.headlineSmall),
            const SizedBox(height: 16),
            for (final d in Difficulty.values) ...[
              _DifficultyTile(d: d),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            Text(
              context.l10n.difficultyRule(SudokuController.maxWrong),
              textAlign: TextAlign.center,
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyTile extends StatelessWidget {
  const _DifficultyTile({required this.d});

  final Difficulty d;

  @override
  Widget build(BuildContext context) {
    final level = d.index + 1;
    return Material(
      color: AppTheme.bg,
      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
        onTap: () => Navigator.pop(context, d),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    d.label(context.l10n),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (var i = 1; i <= 5; i++)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= level ? AppTheme.primary : AppTheme.border,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
