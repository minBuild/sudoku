import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../controllers/sudoku_controller.dart';
import '../flows/game_feedback.dart';
import '../flows/game_session_observer.dart';
import '../flows/hint_flow.dart';
import '../flows/reward_flow.dart';
import '../l10n/l10n.dart';
import '../l10n/difficulty_label.dart';
import '../models/game_status.dart';
import '../services/settings_store.dart';
import '../theme/app_theme.dart';
import '../theme/sudoku_colors.dart';
import '../util/format.dart';
import '../widgets/board/sudoku_board.dart';
import '../widgets/nickname_dialog.dart';
import '../widgets/number_pad.dart';
import '../widgets/result_sheet.dart';
import '../widgets/stat_chip.dart';
import '../widgets/tool_bar.dart';
import 'prepare_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum _MenuAction { restart, instantCheck, sound }

class _GameScreenState extends State<GameScreen> {
  late final SudokuController _c;
  late final AppDeps _deps;
  late final SettingsStore _settings;
  late final GameSessionObserver _obs;
  late final GameFeedback _feedback;
  late final StreamSubscription<GameEffect> _fx;
  final _boardKey = GlobalKey<SudokuBoardState>();

  @override
  void initState() {
    super.initState();
    _c = context.read<SudokuController>();
    final deps = _deps = context.read<AppDeps>();
    _settings = deps.settings;
    deps.hintBudget.refresh();
    _obs = GameSessionObserver(
      _c,
      deps.records,
      deps.settings,
      deps.saves,
      onFinished: _onFinished,
    );
    _feedback = GameFeedback(_c, deps.sound, deps.settings);
    _fx = _c.effects.listen(_onEffect);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _obs.startWhenVisible();
    });
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _fx.cancel();
    _feedback.dispose();
    _obs.flushAndDispose();
    super.dispose();
  }

  void _onEffect(GameEffect e) {
    switch (e) {
      case GameEffect.wrong || GameEffect.conflict || GameEffect.failed:
        _boardKey.currentState?.shake();
        // 한 번만 더 틀리면 게임 오버. 이어 도전 광고를 미리 불러 둔다.
        if (e == GameEffect.wrong &&
            _c.wrongCount == SudokuController.maxWrong - 1 &&
            !_deps.entitlement.adsRemoved.value) {
          _deps.ads.preloadRewarded();
        }
      case GameEffect.firstMistake:
        if (_settings.mistakeHintShown || !mounted) return;
        _settings.markMistakeHintShown();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.mistakeKept)));
      case GameEffect.selected ||
          GameEffect.accepted ||
          GameEffect.placed ||
          GameEffect.noted ||
          GameEffect.solved ||
          GameEffect.hinted:
        break;
    }
  }

  Future<void> _onFinished(GameStatus status, bool isNewBest) async {
    if (!mounted) return;
    final solved = status == GameStatus.solved;
    final board = _c.weeklyBoard;
    final weekly = _deps.weekly;
    final adsRemoved = _deps.entitlement.adsRemoved.value;
    final a = await ResultSheet.show(
      context,
      solved: solved,
      elapsedSeconds: _c.elapsedMs ~/ 1000,
      wrongCount: _c.wrongCount,
      difficulty: _c.difficulty,
      isNewBest: isNewBest,
      elapsedMs: _c.elapsedMs,
      weekly: board != null,
      weeklyState: solved && board != null && weekly != null
          ? weekly.onCleared(
              board: board,
              ms: _c.elapsedMs,
              hintsUsed: _c.hintsUsed,
            )
          : null,
      onContinue: solved
          ? null
          : adsRemoved
          ? () async => true
          : () => runRewardFlow(context, purpose: RewardPurpose.continueGame),
      continueNeedsAd: !adsRemoved,
      onSetNickname: weekly == null
          ? null
          : (ctx) => NicknameDialog.showAndSave(ctx, weekly),
    );
    if (!mounted) return;
    switch (a) {
      case ResultAction.continueGame:
        _c.continueAfterFail();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _obs.startWhenVisible();
        });
      case ResultAction.newGame:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => PrepareScreen(difficulty: _c.difficulty),
          ),
        );
      case ResultAction.retry:
        _restart();
      case ResultAction.home:
      case null:
        Navigator.pop(context);
    }
  }

  void _restart() {
    _c.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _obs.startWhenVisible();
    });
  }

  Future<void> _onMenu(_MenuAction a) async {
    switch (a) {
      case _MenuAction.restart:
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(context.l10n.restartConfirmTitle),
            content: Text(context.l10n.restartConfirmBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(context.l10n.restartSame),
              ),
            ],
          ),
        );
        if (ok == true && mounted && !_c.status.isOver) _restart();
      case _MenuAction.instantCheck:
        _c.setInstantCheck(!_c.instantCheck);
      case _MenuAction.sound:
        await _settings.setSoundEnabled(!_settings.soundEnabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth, h = box.maxHeight;
            return w > h ? _landscape(w, h) : _portrait(w, h);
          },
        ),
      ),
    );
  }

  Widget _portrait(double w, double h) {
    final contentW = math.min(w, AppTheme.maxContentWidth);
    final boardSize = math.max(0.0, math.min(contentW - 32, h * 0.52));
    return Center(
      child: SizedBox(
        width: contentW,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _TopBar(onMenu: _onMenu),
              const SizedBox(height: 4),
              const _Chips(),
              Expanded(
                child: LayoutBuilder(
                  // 큰 글꼴로 컨트롤이 커지면 보드가 남은 높이에 맞춰 줄어든다.
                  builder: (context, area) => Center(
                    child: SizedBox.square(
                      dimension: math.max(
                        0.0,
                        math.min(boardSize, area.maxHeight - 16),
                      ),
                      child: SudokuBoard(key: _boardKey),
                    ),
                  ),
                ),
              ),
              _toolBar(),
              const SizedBox(height: 12),
              const NumberPad(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolBar() {
    final removed = _deps.entitlement.adsRemoved;
    final free = _deps.hintBudget.freeLeft;
    return ListenableBuilder(
      listenable: Listenable.merge([removed, free]),
      builder: (context, _) => GameToolBar(
        onHint: () => requestHint(
          context,
          _c,
          resume: _obs.startWhenVisible,
          alive: () => mounted && !_disposed,
        ),
        hintState: removed.value
            ? const HintButtonState.unlimited()
            : free.value > 0
            ? HintButtonState.free(free.value)
            : const HintButtonState.needAd(),
      ),
    );
  }

  Widget _landscape(double w, double h) {
    final boardSize = math.max(0.0, math.min(h - 32, w * 0.55));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox.square(
            dimension: boardSize,
            child: SudokuBoard(key: _boardKey),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    _TopBar(onMenu: _onMenu),
                    const SizedBox(height: 8),
                    const _Chips(),
                    const SizedBox(height: 16),
                    _toolBar(),
                    const SizedBox(height: 12),
                    const NumberPad(columns: 3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onMenu});

  final ValueChanged<_MenuAction> onMenu;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SudokuController>();
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          IconButton(
            tooltip: context.l10n.back,
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppTheme.textSecondary,
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        c.difficulty.label(context.l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<_MenuAction>(
            tooltip: context.l10n.more,
            icon: const Icon(Icons.more_vert_rounded),
            iconColor: AppTheme.textSecondary,
            onSelected: onMenu,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _MenuAction.restart,
                enabled: !c.status.isOver,
                child: Text(context.l10n.restartSame),
              ),
              CheckedPopupMenuItem(
                value: _MenuAction.instantCheck,
                checked: c.instantCheck,
                enabled: !c.status.isOver,
                child: Text(context.l10n.instantCheck),
              ),
              // 게임이 끝난 뒤에도 끌 수 있다.
              CheckedPopupMenuItem(
                value: _MenuAction.sound,
                checked: context.read<AppDeps>().settings.soundEnabled,
                child: Text(context.l10n.soundEffects),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<SudokuController>();
    final colors = SudokuColors.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // 1초마다 칩만 다시 그린다 (보드는 그대로).
          ValueListenableBuilder<int>(
            valueListenable: c.elapsedSeconds,
            builder: (_, s, _) =>
                StatChip(icon: Icons.timer_outlined, text: formatClock(s)),
          ),
          if (c.weeklyBoard != null)
            c.hintsUsed == 0
                ? StatChip(
                    icon: Icons.emoji_events_outlined,
                    text: context.l10n.weeklyTitle,
                  )
                : StatChip(
                    icon: Icons.visibility_off_outlined,
                    text: context.l10n.rankingExcluded,
                    color: AppTheme.textSecondary,
                  ),
          if (c.instantCheck)
            StatChip(
              icon: Icons.close_rounded,
              text: context.l10n.mistakes(
                c.wrongCount,
                SudokuController.maxWrong,
              ),
              color: c.wrongCount >= SudokuController.maxWrong - 1
                  ? colors.warning
                  : AppTheme.text,
            ),
        ],
      ),
    );
  }
}
