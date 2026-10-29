import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/sudoku_puzzle.dart';
import '../sudoku_generator.dart';
import 'iso_week.dart';

/// 주간 시드 퍼즐 캐시 (W4). 두 번째 진입부터 생성 없이 바로 시작한다.
///
/// `{ "<weekKey>_<difficulty>_g<ver>": {"seed", "init", "sol", "wk"} }`
class WeeklyPuzzleCache {
  WeeklyPuzzleCache(this._prefs, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const _key = 'weekly_puzzle_v1';

  final SharedPreferences _prefs;
  final DateTime Function() _now;

  Future<SudokuPuzzle> getOrCreate(
    PuzzleRequest r,
    Future<SudokuPuzzle> Function() make,
  ) async {
    final wk = r.weekKey;
    final seed = r.seed;
    if (wk == null || seed == null) return make();
    final id = '${wk}_${r.difficulty.name}_g$kGeneratorVersion';

    // 조회가 정리보다 먼저다. 지난 주 보드 요청도 캐시에 있으면 그대로 쓴다.
    final hit = _decode(_read()[id], seed);
    if (hit != null) return hit;

    final puzzle = await make();
    try {
      // 생성 중에 주가 바뀌었을 수 있으므로 지금 시각을 다시 읽는다.
      final keep = {isoWeekKey(_now()), wk};
      final map = _read()
        ..removeWhere((_, v) => v is! Map || !keep.contains(v['wk']))
        ..[id] = {
          'seed': seed,
          'init': _encode(puzzle.initial),
          'sol': _encode(puzzle.solution),
          'wk': wk,
        };
      await _prefs.setString(_key, jsonEncode(map));
    } catch (e) {
      debugPrint('WeeklyPuzzleCache: 저장 실패 ($e)');
    }
    return puzzle;
  }

  Map<String, dynamic> _read() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) return {};
      final m = jsonDecode(raw);
      return m is Map<String, dynamic> ? m : {};
    } catch (_) {
      return {};
    }
  }

  static SudokuPuzzle? _decode(Object? e, int seed) {
    if (e is! Map || e['seed'] != seed) return null;
    final init = _grid(e['init'], min: 0);
    final sol = _grid(e['sol'], min: 1);
    if (init == null || sol == null) return null;
    return SudokuPuzzle(initial: init, solution: sol);
  }

  static String _encode(List<List<int>> g) => [for (final r in g) ...r].join();

  static List<List<int>>? _grid(Object? raw, {required int min}) {
    if (raw is! String || raw.length != 81) return null;
    final cells = <int>[];
    for (var i = 0; i < 81; i++) {
      final v = raw.codeUnitAt(i) - 0x30;
      if (v < min || v > 9) return null;
      cells.add(v);
    }
    return List.generate(9, (r) => cells.sublist(r * 9, r * 9 + 9));
  }
}
