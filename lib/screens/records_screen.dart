import 'package:flutter/material.dart';

import '../models/difficulty.dart';
import '../models/game_record.dart';
import '../services/record_store.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final RecordStore _store = RecordStore();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Difficulty.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _mmss(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _dateLabel(DateTime dt) {
    final local = dt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final mo = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final mi = local.minute.toString().padLeft(2, '0');
    return '$y-$mo-$d $h:$mi';
  }

  GameRecord? _bestOf(List<GameRecord> records) {
    if (records.isEmpty) return null;

    final sorted = [...records]
      ..sort((a, b) {
        final t = a.elapsedSeconds.compareTo(b.elapsedSeconds);
        if (t != 0) return t;
        return a.wrongCount.compareTo(b.wrongCount);
      });

    return sorted.first;
  }

  Widget _bestHeader(GameRecord best) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber),
          const SizedBox(width: 8),
          Text(
            'BEST ${_mmss(best.elapsedSeconds)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            '❌: ${best.wrongCount}',
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: Difficulty.values.map((d) => Tab(text: d.label)).toList(),
        ),
        actions: [
          IconButton(
            tooltip: 'Full deletion',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Do you want me to delete the record?'),
                  content: const Text('Recovery is not possible.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('❌'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('🗑️'),
                    ),
                  ],
                ),
              );

              if (ok == true) {
                await _store.clearAll();
                if (!mounted) return;
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: Difficulty.values.map((d) {
          return FutureBuilder<List<GameRecord>>(
            future: _store.loadAll().then((all) => all.where((r) => r.difficulty == d).toList()),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final records = snap.data ?? [];
              if (records.isEmpty) {
                return const Center(child: Text('Do not have a record yet'));
              }

              final best = _bestOf(records);

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: records.length + (best != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == 0 && best != null) {
                    return _bestHeader(best);
                  }

                  final recordIndex = best != null ? index - 1 : index;
                  final r = records[recordIndex];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text('🕗 ${_mmss(r.elapsedSeconds)}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('❌: ${r.wrongCount}'),
                            const SizedBox(height: 2),
                            Text(
                              _dateLabel(r.finishedAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
