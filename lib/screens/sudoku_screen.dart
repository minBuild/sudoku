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
  final RecordStore _recordStore = RecordStore();

  // 다이얼로그 중복 방지 플래그
  bool _hasShownSolved = false;
  bool _hasShownGameOver = false;

  @override
  void initState() {
    super.initState();
    // 성능 최적화를 위해 addListener 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SudokuController>().addListener(_checkGameState);
    });
  }

  // 화면 갱신 없이 상태만 체크 (최적화)
  void _checkGameState() {
    if (!mounted) return;
    final controller = context.read<SudokuController>();

    // 리셋 체크
    if (!controller.isSolved && _hasShownSolved) _hasShownSolved = false;
    if (!controller.isGameOver && _hasShownGameOver) _hasShownGameOver = false;

    // 클리어/게임오버 체크
    if (controller.isSolved && !_hasShownSolved) {
      _hasShownSolved = true;
      _showSolvedDialog(controller);
    } else if (controller.isGameOver && !_hasShownGameOver) {
      _hasShownGameOver = true;
      _showGameOverDialog(controller);
    }
  }

  Future<void> _showGameOverDialog(SudokuController controller) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Game Over.\nWhat do you want?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.reset();
              },
              child: const Text('Restart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSolvedDialog(SudokuController controller) async {
    await _recordStore.add(
      GameRecord(
        difficulty: controller.difficulty,
        elapsedSeconds: controller.elapsedSeconds,
        wrongCount: controller.wrongCount,
        finishedAt: DateTime.now(),
      ),
    );

    if (!mounted) return;

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
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Home'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.reset();
              },
              child: const Text('Restart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
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
    if (controller.isGameOver || controller.isSolved) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

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
    // 가로 모드인지 확인
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // 가로 모드일 때는 앱바 높이를 좀 줄여주는 게 좋습니다.
        toolbarHeight: isLandscape ? 60 : 100,
        title: Image.asset(
          'assets/images/title.png',
          height: isLandscape ? 50 : 100,
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
      body: SafeArea(
        bottom: false,
        child: isLandscape
            ? _buildLandscapeLayout(context, controller) // 가로 모드 레이아웃
            : _buildPortraitLayout(context, controller), // 세로 모드 레이아웃 (기존)
      ),
    );
  }

  // 📱 세로 모드 레이아웃 (기존 코드와 동일)
  Widget _buildPortraitLayout(BuildContext context, SudokuController controller) {
    return Column(
      children: [
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth;
            final topPad = (size).clamp(25.0, 100.0);

            return Padding(
              padding: EdgeInsets.only(top: topPad),
              child: SizedBox(
                height: size,
                child: _buildBoardWithBadges(controller), // 보드+배지 분리
              ),
            );
          },
        ),
        const Spacer(), // 남은 공간 밀어내기
        _buildControlPanel(controller), // 컨트롤 패널 (Undo/Clear/Note)
        const SizedBox(height: 10),
        const _NumberPad(),
        const SizedBox(height: 20),
      ],
    );
  }

  // 💻 가로 모드 레이아웃 (태블릿 등)
  Widget _buildLandscapeLayout(BuildContext context, SudokuController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 왼쪽: 보드 (최대한 크게)
        Expanded(
          flex: 5,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildBoardWithBadges(controller),
              ),
            ),
          ),
        ),
        // 오른쪽: 컨트롤 패널
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlPanel(controller),
                const SizedBox(height: 30),
                // 가로 모드에서는 숫자 패드가 너무 옆으로 길어지면 안 예쁘니 Wrap으로 감싸거나 그대로 둡니다.
                // 여기서는 기존 _NumberPad가 Row 기반이라 그대로 씁니다.
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _NumberPad(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 🧩 보드와 배지(타이머/실수)를 묶은 위젯
  Widget _buildBoardWithBadges(SudokuController controller) {
    return Stack(
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
    );
  }

  // 🎛️ Undo, Clear, Note 버튼 패널
  Widget _buildControlPanel(SudokuController controller) {
    return Padding(
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
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SudokuController>();

    // [수정 1] 여기서 .where로 거르지 말고 1~9 모든 숫자를 가져옵니다.
    final numbers = List<int>.generate(9, (i) => i + 1);

    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: numbers.map((number) {
          // [수정 2] 완료 여부를 확인합니다.
          final isCompleted = controller.isNumberCompleted(number);

          // [핵심] 완료된 숫자는 '버튼' 대신 '빈 공간(SizedBox)'을 리턴합니다.
          // Expanded로 감싸져 있기 때문에 여전히 1/9 공간을 차지합니다!
          if (isCompleted) {
            return const Expanded(
              child: SizedBox(),
            );
          }

          // 완료되지 않은 숫자는 정상적으로 버튼을 보여줍니다.
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
