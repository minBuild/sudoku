import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/models/difficulty.dart';

import '../controllers/sudoku_controller.dart';
import '../widgets/sudoku_board.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  bool _shownGameOverDialog = false;
  bool _shownSolvedDialog = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.watch<SudokuController>();

    // ✅ 클리어 되었고, 아직 다이얼로그 안 띄웠으면 1회만 띄움
    if (controller.isSolved && !_shownSolvedDialog) {
      _shownSolvedDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSolvedDialog(controller);
      });
    }

    // ✅ 게임오버 되었고, 아직 다이얼로그 안 띄웠으면 1회만 띄움
    if (controller.isGameOver && !_shownGameOverDialog) {
      _shownGameOverDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog(controller);
      });
    }

    // ✅ 새 게임/리셋되면 플래그 초기화
    if (!controller.isSolved && _shownSolvedDialog) {
      _shownSolvedDialog = false;
    }
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
          title: const Text('Game Over'),
          content: Text('Game Over.\nWhat do you want?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.reset(); // ✅ 다시 시작(같은 퍼즐/현재 샘플)
              },
              child: const Text('Restart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).popUntil((route) => route.isFirst); // 홈으로
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSolvedDialog(SudokuController controller) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('🎉 Clear!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.difficulty.label),
              const SizedBox(height: 6),
              Text('Time: ${controller.elapsedLabel}'),
              const SizedBox(height: 6),
              Text('❌: ${controller.wrongCount}/${SudokuController.maxWrongCount}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 홈으로
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Home'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.reset(); // 같은 퍼즐 다시하기
              },
              child: const Text('Restart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // "새 게임"은 홈에서 난이도 선택 정책이면 홈으로 보내기
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmGoHome(SudokuController controller) async {
    // 이미 게임이 끝났으면 바로 홈으로
    if (controller.isGameOver || controller.isSolved) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // 진행 중이면 확인 다이얼로그
    final bool? abandon = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Go Home?'),
        content: const Text('The game currently in progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('❌'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('🏡'),
          ),
        ],
      ),
    );

    if (abandon == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SudokuController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        title: Image.asset(
          'assets/images/title.png',
          height: 100,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            onPressed: () => controller.reset(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => _confirmGoHome(controller),
            icon: const Icon(Icons.home),
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
                    left: 15,
                    child: _TimerBadge(label: controller.elapsedLabel),
                  ),

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
                      ? '🎉 Success!'
                      : controller.isGameOver
                      ? 'Game Over'
                      : controller.isNoteMode
                      ? '📝'
                      : '🖊️',
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
                      child: const Text('🧹 Clear Selected'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: controller.isGameOver ? null : controller.toggleNoteMode,
                      icon: Icon(
                        controller.isNoteMode ? Icons.edit_note : Icons.edit,
                      ),
                      label: Text(
                        controller.isNoteMode ? 'NoteMode' : 'InputMode',
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
    final controller = context.watch<SudokuController>();

    return SizedBox(
      height: 56,
      child: Row(
        children: List.generate(9, (index) {
          final number = index + 1;
          final isCompleted = controller.isNumberCompleted(number);

          if (isCompleted) {
            // ✅ 다 사용한 숫자는 공간만 차지 (레이아웃 유지)
            return const Expanded(child: SizedBox.shrink());
          }

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: ElevatedButton(
                onPressed: controller.isGameOver
                    ? null
                    : () => controller.inputNumber(number),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    fontSize: 20,
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
        '❌ $wrong/$maxWrong',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  final String label;

  const _TimerBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
