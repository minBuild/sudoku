import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/sudoku_controller.dart';
import '../models/sudoku_cell.dart';

class SudokuCellWidget extends StatelessWidget {
  final SudokuCell cell;

  const SudokuCellWidget({super.key, required this.cell});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SudokuController>();

    Color bgColor = Colors.white;

    if (cell.isGiven) {
      bgColor = Colors.grey.shade200;     // 기본 고정 숫자
    }
    if (cell.isHighlighted) {
      bgColor = Colors.yellow.shade100;   // 행/열/박스 하이라이트
    }
    if (cell.isSelected) {
      bgColor = Colors.blue.shade100;     // 선택된 칸
    }
    if (cell.isWrong) {
      bgColor = Colors.orange.shade200;
    }
    if (cell.isConflicted) {
      bgColor = Colors.red.shade200;      // 충돌이 최우선
    }


    // 3x3 박스 경계선 두껍게
    final bool outerTop = cell.row == 0;
    final bool outerLeft = cell.col == 0;
    final bool outerRight = cell.col == 8;
    final bool outerBottom = cell.row == 8;

    final bool blockTop = cell.row % 3 == 0;
    final bool blockLeft = cell.col % 3 == 0;
    final bool blockRight = (cell.col + 1) % 3 == 0;
    final bool blockBottom = (cell.row + 1) % 3 == 0;


    final majorLineColor = Colors.black;
    final minorLineColor = Colors.black.withValues(alpha: 0.25);

    double w(bool isOuter, bool isBlock) => isOuter ? 4 : (isBlock ? 2 : 0.5);
    Color c(bool isOuter, bool isBlock) => (isOuter || isBlock) ? majorLineColor : minorLineColor;


    return GestureDetector(
      onTap: () => controller.selectCell(cell.row, cell.col),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            top: BorderSide(
              width: w(outerTop, blockTop),
              color: c(outerTop, blockTop),
            ),
            left: BorderSide(
              width: w(outerLeft, blockLeft),
              color: c(outerLeft, blockLeft),
            ),
            right: BorderSide(
              width: w(outerRight, blockRight),
              color: c(outerRight, blockRight),
            ),
            bottom: BorderSide(
              width: w(outerBottom, blockBottom),
              color: c(outerBottom, blockBottom),
            ),
          ),
        ),
        child: Center(
          child: _buildCellContent(cell),
        ),
      ),
    );
  }
}

Widget _buildCellContent(SudokuCell cell) {
  // ✅ 값이 있으면: 셀 크기에 비례해서 크게 표시 + 주어진 숫자는 더 굵게
  if (cell.value != null) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;          // 한 칸 크기
        final base = size * 0.55;                  // 전체 숫자 크기(조절 포인트)
        final given = size * 0.60;                 // 주어진 숫자 더 큼(조절 포인트)

        return Text(
          cell.value!.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cell.isGiven ? given : base,
            fontWeight: cell.isGiven ? FontWeight.w900 : FontWeight.w600,
            color: cell.isGiven
                ? Colors.black
                : const Color(0xFF1E3A8A), // ✅ 입력 숫자 색
          ),
        );
      },
    );
  }

  // ✅ 값은 없고 메모가 있으면: 기존 그대로(원하면 NotesView 폰트도 키울 수 있음)
  if (cell.notes.isNotEmpty) {
    return _NotesView(notes: cell.notes);
  }

  return const SizedBox.shrink();
}

class _NotesView extends StatelessWidget {
  final Set<int> notes;

  const _NotesView({required this.notes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        final fontSize = size * 0.29; // 메모 글자 크기 (조절 포인트)

        return SizedBox(
          width: size,
          height: size,
          child: GridView.count(
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: List.generate(9, (i) {
              final num = i + 1;
              final has = notes.contains(num);

              return Center(
                child: has
                    ? Text(
                  num.toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black54,
                  ),
                )
                    : const SizedBox.shrink(),
              );
            }),
          ),
        );
      },
    );
  }
}
