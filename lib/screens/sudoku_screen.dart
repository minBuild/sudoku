import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../widgets/sudoku_board.dart';

class SudokuScreen extends StatelessWidget {
  const SudokuScreen({super.key});

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
          // 숫자 입력 패드
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  controller.isSolved ? '🎉 완료되었습니다!'
                      : controller.isNoteMode
                      ? '메모 모드: 후보 숫자를 기록해보세요'
                      : '입력 모드: 숫자를 선택해서 정답을 맞춰보세요',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                _NumberPad(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => controller.clearSelectedCell(),
                      child: const Text('선택된 칸 지우기'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => controller.toggleNoteMode(),
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
  @override
  Widget build(BuildContext context) {
    final controller = context.read<SudokuController>();

    return SizedBox(
      height: 56, // 숫자 패드 전체 높이
      child: Row(
        children: List.generate(9, (index) {
          final number = index + 1;

          return Expanded(
            // 9등분해서 한 줄에 꽉 채우기
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                onPressed: () => controller.inputNumber(number),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    fontSize: 20,  // 숫자 확실히 보이게
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
