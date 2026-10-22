import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../l10n/difficulty_label.dart';
import '../models/difficulty.dart';
import '../models/game_record.dart';
import '../services/record_store.dart';
import '../theme/app_theme.dart';
import '../util/format.dart';

const _noBest = '--:--';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late final RecordStore _store = context.read<RecordStore>();
  List<GameRecord>? _records;
  Difficulty? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await _store.loadAll();
    if (mounted) setState(() => _records = r);
  }

  Future<void> _clearAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.clearAllTitle),
        content: Text(context.l10n.clearAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _store.clearAll();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final records = _records;
    final hasRecords = records != null && records.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.records),
        actions: [
          IconButton(
            tooltip: context.l10n.clearAll,
            onPressed: hasRecords ? _clearAll : null,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: records == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppTheme.maxContentWidth,
                ),
                child: _body(records),
              ),
            ),
    );
  }

  Widget _body(List<GameRecord> all) {
    final text = Theme.of(context).textTheme;
    final filtered = _filter == null
        ? all
        : all.where((r) => r.difficulty == _filter).toList();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _filterChips()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.pagePadding),
          sliver: SliverToBoxAdapter(child: _BestCard(records: all)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pagePadding,
            24,
            AppTheme.pagePadding,
            8,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              context.l10n.recentRecords(filtered.length),
              style: text.headlineSmall,
            ),
          ),
        ),
        if (filtered.isEmpty)
          const SliverToBoxAdapter(child: _Empty())
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.pagePadding,
              0,
              AppTheme.pagePadding,
              24,
            ),
            sliver: SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _RecordTile(record: filtered[i]),
            ),
          ),
      ],
    );
  }

  Widget _filterChips() {
    Widget chip(String label, Difficulty? d) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == d,
        onSelected: (_) => setState(() => _filter = d),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: _filter == d ? Colors.white : AppTheme.text,
        ),
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppTheme.pagePadding,
        4,
        AppTheme.pagePadding,
        16,
      ),
      child: Row(
        children: [
          chip(context.l10n.all, null),
          for (final d in Difficulty.values) chip(d.label(context.l10n), d),
        ],
      ),
    );
  }
}

class _BestCard extends StatelessWidget {
  const _BestCard({required this.records});

  final List<GameRecord> records;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final best = <Difficulty, int>{};
    for (final r in records) {
      final b = best[r.difficulty];
      if (b == null || r.elapsedSeconds < b) {
        best[r.difficulty] = r.elapsedSeconds;
      }
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.bestRecords, style: text.titleMedium),
                    Text(context.l10n.bestRecordsSub, style: text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, box) {
              final w = (box.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final d in Difficulty.values)
                    SizedBox(
                      width: w,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.label(context.l10n), style: text.bodySmall),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                best[d] == null
                                    ? _noBest
                                    : formatClock(best[d]!),
                                style: text.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: AppTheme.tabular,
                                  color: best[d] == null
                                      ? AppTheme.textSecondary
                                      : AppTheme.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final GameRecord record;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Badge(
                record.difficulty.label(context.l10n),
                bg: AppTheme.primaryTint,
                fg: AppTheme.primary,
              ),
              if (!record.instantCheck)
                _Badge(
                  context.l10n.checkOff,
                  bg: Color(0xFFF3F4F6),
                  fg: AppTheme.textSecondary,
                ),
              Text(
                context.l10n.recordDate(record.finishedAt),
                style: text.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.clearTime, style: text.bodySmall),
                    Text(
                      formatClock(record.elapsedSeconds),
                      style: text.headlineMedium?.copyWith(
                        fontSize: 22,
                        fontFeatures: AppTheme.tabular,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.recordMistakes(record.wrongCount),
                      style: text.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, {required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(context.l10n.noRecords, style: text.titleMedium),
          const SizedBox(height: 4),
          Text(
            context.l10n.noRecordsSub,
            textAlign: TextAlign.center,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
