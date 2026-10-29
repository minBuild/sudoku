import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../l10n/difficulty_label.dart';
import '../controllers/sudoku_controller.dart';
import '../models/difficulty.dart';
import '../services/purchase/entitlement_store.dart';
import '../services/purchase/purchase_service.dart';
import '../services/weekly/weekly_service.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';

enum ResultAction { newGame, retry, home, continueGame }

/// 결과 바텀시트. 화면 이동은 하지 않고 `pop(ctx, ResultAction)` 만 한다 (D19).
/// 이어 도전은 시트 안에서 처리하고 성공했을 때만 닫는다 (W18).
class ResultSheet extends StatefulWidget {
  const ResultSheet({
    super.key,
    required this.solved,
    required this.elapsedSeconds,
    required this.wrongCount,
    required this.difficulty,
    required this.isNewBest,
    this.elapsedMs,
    this.weekly = false,
    this.weeklyState,
    this.onContinue,
    this.continueNeedsAd = true,
    this.onSetNickname,
  });

  final bool solved;
  final int elapsedSeconds;
  final int wrongCount;
  final Difficulty difficulty;
  final bool isNewBest;

  /// 주간 판은 시간을 mm:ss.s 로 보여 준다 (W23).
  final int? elapsedMs;
  final bool weekly;
  final ValueListenable<WeeklySubmitState>? weeklyState;

  /// 게임 오버에서 이어 도전. true 면 시트를 닫는다.
  final Future<bool> Function()? onContinue;
  final bool continueNeedsAd;

  /// 1등인데 닉네임이 없을 때. 1회 자동으로 부르고 시트 안 버튼에도 쓴다 (W22).
  final Future<void> Function(BuildContext)? onSetNickname;

  static Future<ResultAction?> show(
    BuildContext context, {
    required bool solved,
    required int elapsedSeconds,
    required int wrongCount,
    required Difficulty difficulty,
    required bool isNewBest,
    int? elapsedMs,
    bool weekly = false,
    ValueListenable<WeeklySubmitState>? weeklyState,
    Future<bool> Function()? onContinue,
    bool continueNeedsAd = true,
    Future<void> Function(BuildContext)? onSetNickname,
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
        elapsedMs: elapsedMs,
        weekly: weekly,
        weeklyState: weeklyState,
        onContinue: onContinue,
        continueNeedsAd: continueNeedsAd,
        onSetNickname: onSetNickname,
      ),
    ),
  );

  @override
  State<ResultSheet> createState() => _ResultSheetState();
}

class _ResultSheetState extends State<ResultSheet> {
  bool _busy = false;
  bool _nickAsked = false;

  @override
  void initState() {
    super.initState();
    widget.weeklyState?.addListener(_onWeekly);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onWeekly());
  }

  @override
  void dispose() {
    widget.weeklyState?.removeListener(_onWeekly);
    super.dispose();
  }

  /// `Rank1(needsNick)` 가 되면 닉네임 입력을 1회만 자동으로 띄운다.
  void _onWeekly() {
    final s = widget.weeklyState?.value;
    final ask = widget.onSetNickname;
    if (!mounted || _nickAsked || ask == null) return;
    if (s is Rank1 && s.needsNick) {
      _nickAsked = true;
      ask(context);
    }
  }

  Future<void> _continue() async {
    final f = widget.onContinue;
    if (f == null || _busy) return;
    setState(() => _busy = true);
    var ok = false;
    try {
      ok = await f();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (ok && mounted) Navigator.pop(context, ResultAction.continueGame);
  }

  void _pop(ResultAction a) => Navigator.pop(context, a);

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final adsRemoved = context.read<EntitlementStore>().adsRemoved;
    final w = widget;
    final solved = w.solved;
    final ms = w.elapsedMs;
    final timeText = w.weekly && ms != null
        ? formatClockTenths(ms)
        : formatClock(w.elapsedSeconds);
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
                  solved ? context.l10n.cleared : context.l10n.gameOver,
                  style: text.headlineMedium,
                ),
                if (solved && w.isNewBest)
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
                      context.l10n.newBest,
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
                  ? context.l10n.clearedSub(w.difficulty.label(context.l10n))
                  : context.l10n.gameOverSub(SudokuController.maxWrong),
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
                    _Stat(context.l10n.time, timeText),
                    const VerticalDivider(width: 1),
                    _Stat(
                      context.l10n.mistakeCount,
                      context.l10n.mistakeTimes(w.wrongCount),
                    ),
                    const VerticalDivider(width: 1),
                    _Stat(
                      context.l10n.difficulty,
                      w.difficulty.label(context.l10n),
                      accent: true,
                    ),
                  ],
                ),
              ),
            ),
            if (w.weeklyState case final ws?) ...[
              const SizedBox(height: 12),
              ValueListenableBuilder<WeeklySubmitState>(
                valueListenable: ws,
                builder: (context, s, _) => _WeeklyLine(
                  state: s,
                  onSetNickname: w.onSetNickname == null
                      ? null
                      : () => w.onSetNickname!(context),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ..._buttons(context),
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

  /// 버튼 위계: 클리어/게임 오버 × 일반/주간.
  List<Widget> _buttons(BuildContext context) {
    final l10n = context.l10n;
    final w = widget;
    Widget primary(IconData icon, String label, VoidCallback? onPressed) =>
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label, textAlign: TextAlign.center),
        );
    Widget tonal(IconData icon, String label, ResultAction a) =>
        FilledButton.tonalIcon(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: AppTheme.primaryTint,
            foregroundColor: AppTheme.primary,
          ),
          onPressed: _busy ? null : () => _pop(a),
          icon: Icon(icon),
          label: Text(label, textAlign: TextAlign.center),
        );
    Widget plain(IconData icon, String label, ResultAction a) =>
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
          onPressed: _busy ? null : () => _pop(a),
          icon: Icon(icon, size: 18),
          label: Text(label, textAlign: TextAlign.center),
        );
    Widget pair(Widget a, Widget b) => Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 8),
        Expanded(child: b),
      ],
    );

    if (!w.solved && w.onContinue != null) {
      final cont = primary(
        w.continueNeedsAd
            ? Icons.ondemand_video_outlined
            : Icons.play_arrow_rounded,
        w.continueNeedsAd ? l10n.continueWithAd : l10n.continueAfterFail,
        _busy ? null : _continue,
      );
      final home = plain(Icons.grid_view_rounded, l10n.home, ResultAction.home);
      return w.weekly
          ? [
              cont,
              const SizedBox(height: 8),
              tonal(
                Icons.refresh_rounded,
                l10n.weeklyRetry,
                ResultAction.retry,
              ),
              const SizedBox(height: 4),
              pair(
                plain(
                  Icons.play_arrow_rounded,
                  l10n.newGame,
                  ResultAction.newGame,
                ),
                home,
              ),
            ]
          : [
              cont,
              const SizedBox(height: 8),
              tonal(
                Icons.play_arrow_rounded,
                l10n.newGame,
                ResultAction.newGame,
              ),
              const SizedBox(height: 4),
              pair(
                plain(
                  Icons.refresh_rounded,
                  l10n.restartSame,
                  ResultAction.retry,
                ),
                home,
              ),
            ];
    }
    if (w.weekly) {
      return [
        primary(
          Icons.refresh_rounded,
          l10n.weeklyRetry,
          () => _pop(ResultAction.retry),
        ),
        const SizedBox(height: 8),
        tonal(Icons.play_arrow_rounded, l10n.newGame, ResultAction.newGame),
        const SizedBox(height: 4),
        plain(Icons.grid_view_rounded, l10n.home, ResultAction.home),
      ];
    }
    return [
      primary(
        Icons.play_arrow_rounded,
        l10n.newGame,
        () => _pop(ResultAction.newGame),
      ),
      const SizedBox(height: 8),
      tonal(Icons.refresh_rounded, l10n.restartSame, ResultAction.retry),
      const SizedBox(height: 4),
      plain(Icons.grid_view_rounded, l10n.home, ResultAction.home),
    ];
  }
}

/// 통계 박스 아래 주간 상태 1줄.
class _WeeklyLine extends StatelessWidget {
  const _WeeklyLine({required this.state, this.onSetNickname});

  final WeeklySubmitState state;
  final VoidCallback? onSetNickname;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = state;
    final (IconData icon, Color color, String label) = switch (s) {
      Sending() => (
        Icons.cloud_upload_outlined,
        AppTheme.textSecondary,
        l10n.weeklySending,
      ),
      MyBest(:final ms) => (
        Icons.timer_outlined,
        AppTheme.primary,
        l10n.weeklyMyBest(formatClockTenths(ms)),
      ),
      Rank1() => (Icons.emoji_events, AppTheme.warning, l10n.weeklyRank1),
      HintExcluded() => (
        Icons.visibility_off_outlined,
        AppTheme.textSecondary,
        l10n.weeklyHintExcluded,
      ),
      LastWeek() => (
        Icons.history_rounded,
        AppTheme.textSecondary,
        l10n.weeklyLastWeek,
      ),
    };
    final rank1 = s is Rank1;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        Icon(icon, size: 18, color: color),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: rank1 || s is MyBest ? AppTheme.text : color,
            fontWeight: rank1 ? FontWeight.w600 : null,
            fontFeatures: AppTheme.tabular,
          ),
        ),
        if (s is Rank1 && s.needsNick && onSetNickname != null)
          TextButton(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            onPressed: onSetNickname,
            child: Text(l10n.nicknameSet),
          ),
      ],
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: text.bodySmall, maxLines: 1),
            ),
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
            ? context.l10n.removeAdsWithPrice(state.price)
            : context.l10n.removeAds;
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            textStyle: const TextStyle(fontSize: 12),
          ),
          onPressed: state is PurchaseReady ? purchase.buy : null,
          child: Text(
            '${context.l10n.resultRemoveAdsLine} $label',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
