import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/strings.dart';
import '../controllers/sudoku_controller.dart';
import '../models/difficulty.dart';
import '../services/purchase/entitlement_store.dart';
import '../services/purchase/purchase_service.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';

enum ResultAction { newGame, retry, home }

/// 결과 바텀시트. 화면 이동은 하지 않고 `pop(ctx, ResultAction)` 만 한다 (D19).
class ResultSheet extends StatelessWidget {
  const ResultSheet({
    super.key,
    required this.solved,
    required this.elapsedSeconds,
    required this.wrongCount,
    required this.difficulty,
    required this.isNewBest,
  });

  final bool solved;
  final int elapsedSeconds;
  final int wrongCount;
  final Difficulty difficulty;
  final bool isNewBest;

  static Future<ResultAction?> show(
    BuildContext context, {
    required bool solved,
    required int elapsedSeconds,
    required int wrongCount,
    required Difficulty difficulty,
    required bool isNewBest,
  }) => showModalBottomSheet<ResultAction>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    builder: (_) => PopScope(
      canPop: false,
      child: ResultSheet(
        solved: solved,
        elapsedSeconds: elapsedSeconds,
        wrongCount: wrongCount,
        difficulty: difficulty,
        isNewBest: isNewBest,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final adsRemoved = context.read<EntitlementStore>().adsRemoved;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: solved
                      ? AppTheme.primaryTint
                      : const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  solved
                      ? Icons.emoji_events_outlined
                      : Icons.sentiment_dissatisfied_outlined,
                  color: solved ? AppTheme.primary : AppTheme.error,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  solved ? S.cleared : S.gameOver,
                  style: text.headlineMedium,
                ),
                if (solved && isNewBest)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      S.newBest,
                      style: text.labelSmall?.copyWith(
                        color: const Color(0xFFB86E00),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              solved
                  ? S.clearedSub(difficulty.label)
                  : S.gameOverSub(SudokuController.maxWrong),
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    _Stat(S.time, formatClock(elapsedSeconds)),
                    const VerticalDivider(width: 1),
                    _Stat(S.mistakeCount, S.mistakeTimes(wrongCount)),
                    const VerticalDivider(width: 1),
                    _Stat(S.difficulty, difficulty.label, accent: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => Navigator.pop(context, ResultAction.newGame),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(S.newGame),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: AppTheme.primaryTint,
                foregroundColor: AppTheme.primary,
              ),
              onPressed: () => Navigator.pop(context, ResultAction.retry),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(S.restartSame),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
              ),
              onPressed: () => Navigator.pop(context, ResultAction.home),
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: Text(S.home),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: adsRemoved,
              builder: (context, removed, _) =>
                  removed ? const SizedBox.shrink() : const _RemoveAdsLine(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.accent = false});

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(label, style: text.bodySmall),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent ? AppTheme.primary : AppTheme.text,
                  fontFeatures: AppTheme.tabular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveAdsLine extends StatelessWidget {
  const _RemoveAdsLine();

  @override
  Widget build(BuildContext context) {
    final purchase = context.read<PurchaseGateway>();
    return ValueListenableBuilder<PurchaseUiState>(
      valueListenable: purchase.state,
      builder: (context, state, _) {
        final label = state is PurchaseReady
            ? S.removeAdsWithPrice(state.price)
            : S.removeAds;
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            textStyle: const TextStyle(fontSize: 12),
          ),
          onPressed: state is PurchaseReady ? purchase.buy : null,
          child: Text(
            '${S.resultRemoveAdsLine} $label',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
