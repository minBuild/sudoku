import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../controllers/sudoku_controller.dart';
import '../l10n/l10n.dart';
import '../models/game_status.dart';
import 'reward_flow.dart';

/// 힌트 버튼. 광고 제거 → 무제한, 무료 남음 → 즉시, 아니면 보상형 광고 1편당 1개.
///
/// 광고로 받은 힌트는 재개보다 먼저 `hint(allowPaused: true)` 로 적용하므로
/// 앱이 hidden 이라 재개가 미뤄져도 보상이 사라지지 않는다 (W14).
Future<void> requestHint(
  BuildContext context,
  SudokuController c, {
  required VoidCallback resume,
  required bool Function() alive,
}) async {
  if (c.status != GameStatus.playing || c.hintTarget == null) return;
  final deps = context.read<AppDeps>();

  if (c.weeklyBoard != null && c.hintsUsed == 0) {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.hintRankingWarn),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.hintUse),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted || !alive()) return;
  }

  if (deps.entitlement.adsRemoved.value) {
    c.hint();
    return;
  }

  final budget = deps.hintBudget;
  budget.refresh();
  if (budget.freeLeft.value > 0) {
    if (c.hint()) await budget.consume();
    return;
  }

  await runRewardFlow(
    context,
    purpose: RewardPurpose.hint,
    pauseTarget: c,
    resumeTarget: resume,
    onEarned: () {
      if (alive()) c.hint(allowPaused: true);
    },
  );
}
