import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../widgets/sudoku_board.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  bool _shownGameOverDialog = false;

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
                controller.reset(); // ✅ 새 게임 (현재는 샘플 퍼즐뿐이라 동일)
                // 나중에 generator 붙이면 controller.newGame()로 바꾸면 됨
              },
              child: const Text('새 게임'),
            ),
          ],
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
          const Expanded(
            flex: 3,
            child: Center(
              child: SudokuBoard(),
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
                      ? '메모 모드: 후보 숫자를 기록해보세요'
                      : '숫자를 선택해서 채워보세요',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  '오답: ${controller.wrongCount}/${SudokuController.maxWrongCount}',
                  style: const TextStyle(fontSize: 14),
                ),
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
