import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/models/difficulty.dart';

import '../controllers/sudoku_controller.dart';
import '../models/game_record.dart';
import '../services/record_store.dart';
import '../widgets/sudoku_board.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  bool _shownGameOverDialog = false;
  bool _shownSolvedDialog = false;
  final RecordStore _recordStore = RecordStore();
  bool _savedClearRecord = false;

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
      _savedClearRecord = false;
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
    if (!_savedClearRecord) {
      _savedClearRecord = true;

      await _recordStore.add(
        GameRecord(
          difficulty: controller.difficulty,
          elapsedSeconds: controller.elapsedSeconds,
          wrongCount: controller.wrongCount,
          finishedAt: DateTime.now(),
        ),
      );

      if (!mounted) return;
    }

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
          const SizedBox(height: 4),
          // 보드 영역
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.maxWidth;

                final topPad = (size).clamp(25.0, 100.0);

                return Padding(
                  padding: EdgeInsets.only(top: topPad),
                  child: SizedBox(
                    height: size,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const SudokuBoard(),
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
                );
              },
            ),
          ),

          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _ControlButton(
                    icon: Icons.undo,
                    label: 'Undo',
                    onTap: controller.isGameOver ? null : controller.rollback,
                  ),
                  _ControlButton(
                    icon: Icons.backspace_outlined,
                    label: 'Clear',
                    onTap: controller.isGameOver ? null : controller.clearSelectedCell,
                  ),
                  _ControlButton(
                    icon: controller.isNoteMode ? Icons.edit_note : Icons.edit,
                    label: controller.isNoteMode ? 'Note' : 'Fill',
                    isActive: controller.isNoteMode,
                    onTap: controller.isGameOver ? null : controller.toggleNoteMode,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          const _NumberPad(),
          const SizedBox(height: 10),
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

    final numbers = List<int>.generate(9, (i) => i + 1)
        .where((n) => !controller.isNumberCompleted(n))
        .toList();

    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: numbers.map((number) {
          final isSelected = controller.selectedNumber == number;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: controller.isGameOver
                    ? null
                    : () => controller.inputNumber(number),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.blue.shade600
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.blue.shade600
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: disabled
                    ? Colors.grey
                    : isActive
                    ? Colors.white
                    : Colors.black87,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: disabled
                      ? Colors.grey
                      : isActive
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
