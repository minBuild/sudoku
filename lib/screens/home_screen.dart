import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../models/difficulty.dart';
import 'records_screen.dart';
import 'sudoku_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickDifficultyAndStart(BuildContext context) async {
    final controller = context.read<SudokuController>();

    final Difficulty? selected = await showDialog<Difficulty>(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Difficulty.values.map((d) {
            return ListTile(
              title: Text(d.label),
              onTap: () => Navigator.of(context).pop(d),
            );
          }).toList(),
        ),
      ),
    );

    if (selected == null) return;

    controller.newGame(selected);

    // 게임 화면으로 이동
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SudokuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SudokuController>();

    return Scaffold(
      // 🔥 [수정] Center로 감싸서 내용물이 작을 땐 정중앙에 오도록 함
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 300, // 아까 줄인 크기 유지
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _pickDifficultyAndStart(context),
                    child: const Text('New Game 🔢'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RecordsScreen()),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Record'),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Recent: ${controller.difficulty.label}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
