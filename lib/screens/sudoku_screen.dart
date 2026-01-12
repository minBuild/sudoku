import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../models/difficulty.dart';
import '../widgets/sudoku_board.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  bool _shownGameOverDialog = false;

  @override
  void initState() {
    super.initState();

    // 첫 진입 시 난이도 선택 띄우기 (1회)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDifficultyDialog();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.watch<SudokuController>();

    // 게임오버가 되었고, 아직 다이얼로그를 안 띄웠으면 1회만 띄움
    if (controller.isGameOver && !_shownGameOverDialog) {
      _shownGameOverDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(controller);
      });
    }

    // 게임이 리셋되면 플래그도 초기화
    if (!controller.isGameOver && _shownGameOverDialog) {
      _shownGameOverDialog = false;
    }
  }

  Future<void> _showGameOverDialog(SudokuController controller) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('게임 종료'),
          content: Text('오답 ${SudokuController.maxWrongCount}회로 게임이 종료되었습니다.\n무엇을 할까요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.reset(); // ✅ 다시 시작(같은 퍼즐/현재 샘플)
              },
              child: const Text('다시 시작'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDifficultyDialog(); // ✅ 난이도 선택 후 newGame
                // 나중에 generator 붙이면 controller.newGame()로 바꾸면 됨
              },
              child: const Text('새 게임'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDifficultyDialog() async {
    final controller = context.read<SudokuController>();

    await showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('난이도 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Difficulty.values.map((d) {
              return ListTile(
                  title: Text(d.label),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.newGame(d);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SudokuController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: [
          IconButton(
            onPressed: () => controller.reset(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // 보드 영역
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const SudokuBoard(), // 이건 const여도 되지만, 아래 때문에 통째 const를 못 씀

                  Positioned(
                    top: -24,
                    right: 15,
                    child: _WrongCounterBadge(
                      wrong: controller.wrongCount,
                      maxWrong: SudokuController.maxWrongCount,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  controller.isSolved
                      ? '🎉 완료되었습니다!'
                      : controller.isGameOver
                      ? '게임 종료'
                      : controller.isNoteMode
                      ? '📝 메모'
                      : '🖊️ 입력',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 6),
                const SizedBox(height: 8),
                const _NumberPad(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed:
                      controller.isGameOver ? null : controller.clearSelectedCell,
                      child: const Text('선택된 칸 지우기'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: controller.isGameOver ? null : controller.toggleNoteMode,
                      icon: Icon(
                        controller.isNoteMode ? Icons.edit_note : Icons.edit,
                      ),
                      label: Text(
                        controller.isNoteMode ? '메모 모드' : '입력 모드',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SudokuController>();

    return SizedBox(
      height: 56,
      child: Row(
        children: List.generate(9, (index) {
          final number = index + 1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                onPressed: () => controller.inputNumber(number),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  number.toString(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _WrongCounterBadge extends StatelessWidget {
  final int wrong;
  final int maxWrong;

  const _WrongCounterBadge({
    required this.wrong,
    required this.maxWrong,
  });

  @override
  Widget build(BuildContext context) {
    final isDanger = wrong >= maxWrong - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDanger ? Colors.red.shade400 : Colors.black87,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '오답 $wrong/$maxWrong',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
