import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/difficulty.dart';
import '../services/weekly/iso_week.dart';
import '../services/weekly/weekly_service.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';

/// 홈의 주간 대결 카드. 로컬 데이터만 쓴다 (네트워크 없음).
class WeeklyCard extends StatelessWidget {
  const WeeklyCard({super.key, required this.service, required this.onTap});

  final WeeklyService service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return ValueListenableBuilder<int>(
      valueListenable: service.store.changes,
      builder: (context, _, _) {
        final now = service.now;
        final wk = isoWeekKey(now);
        final done = service.store.clearedCount(wk);
        final ends = formatWeekEnd(nextWeekStartUtc(now), l10n.localeName);
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
                        Icons.emoji_events_outlined,
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
                              Text(l10n.weeklyTitle, style: text.titleMedium),
                              _Badge(l10n.weeklyWeekLabel(isoWeekNumber(wk))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${l10n.weeklyClearedCount(done, Difficulty.values.length)}'
                            ' · ${l10n.weeklyEndsAt(ends)}',
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
      },
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
