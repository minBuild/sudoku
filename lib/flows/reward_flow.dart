import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../controllers/sudoku_controller.dart';
import '../l10n/l10n.dart';
import '../models/game_status.dart';
import '../services/ads/ad_service.dart';

enum RewardPurpose { hint, continueGame }

/// 확인 → (게임 일시정지) → 로딩 → 보상형 광고 → 지급 → 재개.
///
/// 보상 지급([onEarned])은 재개([resumeTarget])보다 먼저 한다 (W14).
/// iOS 광고는 라이프사이클 이벤트 없이 뜨므로 여기서 직접 멈춘다 (W13).
Future<bool> runRewardFlow(
  BuildContext context, {
  required RewardPurpose purpose,
  SudokuController? pauseTarget,
  VoidCallback? resumeTarget,
  VoidCallback? onEarned,
}) async {
  final deps = context.read<AppDeps>();
  final ads = deps.ads;
  ads.preloadRewarded();

  final l10n = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(switch (purpose) {
        RewardPurpose.hint => l10n.rewardHintTitle,
        RewardPurpose.continueGame => l10n.continueWithAd,
      }),
      content: Text(switch (purpose) {
        RewardPurpose.hint => l10n.rewardHintBody,
        RewardPurpose.continueGame => l10n.rewardContinueBody,
      }),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(ctx, true),
          icon: const Icon(Icons.ondemand_video_outlined, size: 18),
          label: Text(l10n.watchAd),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return false;

  var paused = false;
  if (pauseTarget?.status == GameStatus.playing) {
    pauseTarget!.pause();
    paused = true;
  }

  var o = RewardOutcome.unavailable;
  try {
    final nav = Navigator.of(context);
    final loading = DialogRoute<void>(
      context: context,
      barrierDismissible: false,
      themes: InheritedTheme.capture(from: context, to: null),
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(l10n.adLoading)),
            ],
          ),
          actions: [
            // 로딩 중에만 효과가 있다. 결과가 unavailable 로 오면 아래에서 닫는다.
            TextButton(onPressed: ads.cancelPending, child: Text(l10n.cancel)),
          ],
        ),
      ),
    );
    nav.push(loading);

    o = await ads.showRewardedAd();

    if (loading.isActive) loading.navigator?.removeRoute(loading);
    if (o == RewardOutcome.earned) onEarned?.call();
  } finally {
    if (paused) resumeTarget?.call();
  }

  if (o != RewardOutcome.unavailable) deps.adSchedule.markShown();
  if (context.mounted && o != RewardOutcome.earned) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          o == RewardOutcome.dismissed
              ? l10n.adNotCompleted
              : l10n.adUnavailable,
        ),
      ),
    );
  }
  return o == RewardOutcome.earned;
}
