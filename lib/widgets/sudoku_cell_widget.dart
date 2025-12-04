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
    if (cell.isConflicted) {
      bgColor = Colors.red.shade200;      // 충돌이 최우선
    }


    // 3x3 박스 경계선 두껍게
    final bool thickTop = cell.row % 3 == 0;
    final bool thickLeft = cell.col % 3 == 0;
    final bool thickRight = cell.col == 8;
    final bool thickBottom = cell.row == 8;

    return GestureDetector(
      onTap: () => controller.selectCell(cell.row, cell.col),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            top: BorderSide(
              width: thickTop ? 2 : 0.5,
              color: Colors.black,
            ),
            left: BorderSide(
              width: thickLeft ? 2 : 0.5,
              color: Colors.black,
            ),
            right: BorderSide(
              width: thickRight ? 2 : 0.5,
              color: Colors.black,
            ),
            bottom: BorderSide(
              width: thickBottom ? 2 : 0.5,
              color: Colors.black,
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
  // 값이 있으면: 기존처럼 크게 숫자 하나
  if (cell.value != null) {
    return Text(
      cell.value!.toString(),
      style: TextStyle(
        fontSize: 18,
        fontWeight: cell.isGiven ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  // 값은 없고 메모가 있으면: 3x3 그리드로 후보 표시
  if (cell.notes.isNotEmpty) {
    return _NotesView(notes: cell.notes);
  }

  // 완전 빈 칸
  return const SizedBox.shrink();
}

class _NotesView extends StatelessWidget {
  final Set<int> notes;

  const _NotesView({required this.notes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth;
        final itemSize = cellSize / 3;
        final fontSize = cellSize / 6;

        return SizedBox(
          width: cellSize,
          height: cellSize,
          child: Column(
            children: List.generate(3, (row) {
              return SizedBox(
                height: itemSize,
                child: Row(
                  children: List.generate(3, (col) {
                    final num = row * 3 + col + 1;
                    final hasNote = notes.contains(num);

                    return SizedBox(
                      width: itemSize,
                      child: Center(
                        child: hasNote
                            ? Text(
                          num.toString(),
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.black54,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
