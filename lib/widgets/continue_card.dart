import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../l10n/difficulty_label.dart';
import '../services/game_save_store.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';

/// 홈의 이어하기 카드.
class ContinueCard extends StatelessWidget {
  const ContinueCard({super.key, required this.meta, required this.onTap});

  final SavedGameMeta meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: AppTheme.card(),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            context.l10n.continueTitle,
                            style: text.titleMedium,
                          ),
                          _Badge(meta.difficulty.label(context.l10n)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.continueDetail(
                          meta.filledRatio,
                          formatClock(meta.elapsedMs ~/ 1000),
                        ),
                        style: text.bodySmall?.copyWith(
                          fontFeatures: AppTheme.tabular,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: AppTheme.primaryTint,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.primary,
      ),
    ),
  );
}
