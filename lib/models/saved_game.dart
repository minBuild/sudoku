import 'dart:typed_data';

import 'difficulty.dart';

/// 진행 중인 판 1개의 직렬화 형식 (v1).
///
/// `notes[i]` 의 bit n-1 이 숫자 n 의 메모다.
class SavedGame {
  static const version = 1;

  final Difficulty difficulty;
  final Uint8List solution;
  final Uint8List initial;
  final Uint8List current;
  final Uint16List notes;
  final int elapsedMs;
  final int wrongCount;
  final bool instantCheck;
  final bool icEverOff;
  final DateTime savedAt;

  SavedGame({
    required this.difficulty,
    required this.solution,
    required this.initial,
    required this.current,
    required this.notes,
    required this.elapsedMs,
    required this.wrongCount,
    required this.instantCheck,
    required this.icEverOff,
    required this.savedAt,
  });

  /// 빈칸 중 채워진 비율 (0.0 ~ 1.0).
  double get filledRatio {
    var holes = 0;
    var filled = 0;
    for (var i = 0; i < 81; i++) {
      if (initial[i] != 0) continue;
      holes++;
      if (current[i] != 0) filled++;
    }
    return holes == 0 ? 1 : filled / holes;
  }

  Map<String, dynamic> toJson() => {
    'v': version,
    'd': difficulty.name,
    'sol': _encode(solution),
    'init': _encode(initial),
    'cur': _encode(current),
    'notes': notes.toList(),
    'elapsedMs': elapsedMs,
    'wrongCount': wrongCount,
    'instantCheck': instantCheck,
    'icEverOff': icEverOff,
    'savedAt': savedAt.toIso8601String(),
  };

  /// 형식이 맞지 않으면 null.
  static SavedGame? tryFromJson(Map<dynamic, dynamic> json) {
    try {
      if (json['v'] != version) return null;
      final d = Difficulty.values.asNameMap()[json['d']];
      if (d == null) return null;

      final sol = _decode(json['sol'], min: 1);
      final init = _decode(json['init'], min: 0);
      final cur = _decode(json['cur'], min: 0);
      if (sol == null || init == null || cur == null) return null;

      final rawNotes = json['notes'];
      if (rawNotes is! List || rawNotes.length != 81) return null;
      final notes = Uint16List(81);
      for (var i = 0; i < 81; i++) {
        final n = rawNotes[i];
        if (n is! int || n < 0 || n > 0x1FF) return null;
        notes[i] = n;
      }

      for (var i = 0; i < 81; i++) {
        if (init[i] != 0 && init[i] != sol[i]) return null;
        if (init[i] != 0 && cur[i] != init[i]) return null;
      }

      final elapsedMs = json['elapsedMs'];
      final wrongCount = json['wrongCount'];
      if (elapsedMs is! int || elapsedMs < 0) return null;
      if (wrongCount is! int || wrongCount < 0) return null;

      return SavedGame(
        difficulty: d,
        solution: sol,
        initial: init,
        current: cur,
        notes: notes,
        elapsedMs: elapsedMs,
        wrongCount: wrongCount,
        instantCheck: json['instantCheck'] as bool? ?? true,
        icEverOff: json['icEverOff'] as bool? ?? false,
        savedAt:
            DateTime.tryParse(json['savedAt'] as String? ?? '') ??
            DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  static String _encode(Uint8List cells) => cells.join();

  static Uint8List? _decode(Object? raw, {required int min}) {
    if (raw is! String || raw.length != 81) return null;
    final out = Uint8List(81);
    for (var i = 0; i < 81; i++) {
      final v = raw.codeUnitAt(i) - 0x30;
      if (v < min || v > 9) return null;
      out[i] = v;
    }
    return out;
  }
}
