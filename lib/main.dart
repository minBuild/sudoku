import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/sudoku_controller.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SudokuController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sudoku',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
