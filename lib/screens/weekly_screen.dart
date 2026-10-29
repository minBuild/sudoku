import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../flows/game_launcher.dart';
import '../l10n/difficulty_label.dart';
import '../l10n/l10n.dart';
import '../services/game_save_store.dart';
import '../services/legal_links.dart';
import '../services/weekly/iso_week.dart';
import '../services/weekly/weekly_board.dart';
import '../services/weekly/weekly_service.dart';
import '../theme/app_theme.dart';
import '../theme/sudoku_colors.dart';
import '../util/format.dart';
import '../widgets/nickname_dialog.dart';
import '../widgets/overwrite_dialog.dart';
import 'prepare_screen.dart';

/// 주간 대결. 난이도별 1등과 내 기록을 보여 주고 도전하게 한다.
/// 순위를 못 불러와도 도전 버튼은 항상 활성이다.
class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({super.key, required this.service});

  final WeeklyService service;

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  WeeklyService get _w => widget.service;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh({bool force = false}) async {
    await _w.flushPending();
    await _w.loadLeaders(force: force);
  }

  Future<void> _play(WeeklyBoard b) async {
    final saves = context.read<GameSaveStore?>();
    final meta = saves?.meta.value;
    if (meta != null && meta.weeklyBoard == b.id) {
      final r = saves!.load();
      if (r is LoadOk) {
        await Navigator.push(context, gameRoute(GameSeed.saved(r.game)));
        if (mounted) _refresh();
        return;
      }
    } else if (meta != null) {
      if (!await confirmOverwrite(context) || !mounted) return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PrepareScreen(difficulty: b.difficulty, weekly: b),
      ),
    );
    if (mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final saves = context.read<GameSaveStore?>();
    final now = _w.now;
    final wk = isoWeekKey(now);
    final boards = WeeklyBoard.current(now);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.weeklyTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTheme.maxContentWidth),
          child: ListenableBuilder(
            listenable: Listenable.merge([
              _w.leaders,
              _w.store.changes,
              ?saves?.meta,
            ]),
            builder: (context, _) {
              final leaders = _w.leaders.value;
              final loading = leaders.values.any((s) => s is LeaderLoading);
              final failed = leaders.values.any((s) => s is LeaderFailed);
              final playing = saves?.meta.value?.weeklyBoard;
              return Column(
                children: [
                  SizedBox(
                    height: 3,
                    child: loading
                        ? const LinearProgressIndicator(
                            backgroundColor: AppTheme.primaryTint,
                          )
                        : null,
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppTheme.pagePadding,
                        8,
                        AppTheme.pagePadding,
                        AppTheme.pagePadding,
                      ),
                      children: [
                        Text(
                          '${l10n.weeklyWeekLabel(isoWeekNumber(wk))}'
                          ' · ${l10n.weeklyEndsAt(formatWeekEnd(nextWeekStartUtc(now), l10n.localeName))}',
                          style: text.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.weeklyRule,
                                style: text.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        if (failed) ...[
                          const SizedBox(height: 12),
                          _FailedBanner(onRetry: () => _refresh(force: true)),
                        ],
                        const SizedBox(height: 16),
                        for (final b in boards) ...[
                          _BoardCard(
                            board: b,
                            leader: leaders[b.id] ?? const LeaderLoading(),
                            myBest: _w.store.bestOf(b.id),
                            inProgress: playing == b.id,
                            hasNick: _w.store.nick != null,
                            onPlay: () => _play(b),
                            onSetNickname: () =>
                                NicknameDialog.showAndSave(context, _w),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 4),
                        _Footer(service: _w),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FailedBanner extends StatelessWidget {
  const _FailedBanner({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 18, color: AppTheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.weeklyLoadFailed,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.text),
            ),
          ),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  const _BoardCard({
    required this.board,
    required this.leader,
    required this.myBest,
    required this.inProgress,
    required this.hasNick,
    required this.onPlay,
    required this.onSetNickname,
  });

  final WeeklyBoard board;
  final LeaderState leader;
  final int? myBest;
  final bool inProgress;
  final bool hasNick;
  final VoidCallback onPlay;
  final VoidCallback onSetNickname;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final warning = SudokuColors.of(context).warning;
    final l = leader;
    final isMe = l is Leader && l.isMe;
    final leaderLine = switch (l) {
      Leader(:final entry) => Row(
        children: [
          Icon(Icons.emoji_events, size: 18, color: warning),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              entry.nick.isEmpty ? l10n.anonymous : entry.nick,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatClockTenths(entry.ms),
            style: text.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: AppTheme.tabular,
            ),
          ),
        ],
      ),
      LeaderEmpty() => Text(
        l10n.weeklyNoLeader,
        style: text.bodyMedium?.copyWith(color: AppTheme.textSecondary),
      ),
      LeaderLoading() || LeaderFailed() => Text(
        '—',
        style: text.bodyMedium?.copyWith(color: AppTheme.textSecondary),
      ),
    };
    final best = myBest;
    final mine = inProgress
        ? l10n.weeklyInProgress
        : best != null
        ? l10n.weeklyMyBest(formatClockTenths(best))
        : l10n.weeklyNotPlayed;
    final label = inProgress
        ? l10n.continueTitle
        : best != null
        ? l10n.weeklyRetry
        : l10n.weeklyChallenge;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card().copyWith(
        border: isMe
            ? Border.all(color: AppTheme.primary, width: 1.5)
            : Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(board.difficulty.label(l10n), style: text.titleMedium),
          const SizedBox(height: 8),
          leaderLine,
          if (isMe && !hasNick) ...[
            const SizedBox(height: 4),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                Text(
                  l10n.weeklyYouAreFirst,
                  style: text.bodyMedium?.copyWith(color: AppTheme.primary),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: onSetNickname,
                  child: Text(l10n.nicknameSet),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  mine,
                  style: text.bodySmall?.copyWith(
                    fontFeatures: AppTheme.tabular,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryTint,
                    foregroundColor: AppTheme.primary,
                  ),
                  onPressed: onPlay,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.service});

  final WeeklyService service;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final nick = service.store.nick;
    return Container(
      decoration: AppTheme.card(),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.person_outline_rounded),
              title: Text(l10n.nickname, style: text.titleMedium),
              subtitle: Text(
                nick ?? l10n.anonymous,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: TextButton(
                onPressed: () => NicknameDialog.showAndSave(context, service),
                child: Text(
                  nick == null ? l10n.nicknameSet : l10n.nicknameChange,
                ),
              ),
            ),
            if (supportEmail.isNotEmpty) ...[
              const Divider(height: 1, indent: 20, endIndent: 20),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Icon(Icons.flag_outlined),
                title: Text(l10n.weeklyReport, style: text.bodyMedium),
                onTap: () => context.read<AppDeps>().openUrl(
                  Uri(scheme: 'mailto', path: supportEmail),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
