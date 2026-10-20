import 'difficulty.dart';

class GameRecord {
  final Difficulty difficulty;
  final int elapsedSeconds;
  final int wrongCount;
  final DateTime finishedAt;

  /// 즉시 체크를 한 번도 끄지 않고 깬 판인지.
  final bool instantCheck;

  GameRecord({
    required this.difficulty,
    required this.elapsedSeconds,
    required this.wrongCount,
    required this.finishedAt,
    this.instantCheck = true,
  });

  Map<String, dynamic> toJson() => {
    'difficulty': difficulty.name,
    'elapsedSeconds': elapsedSeconds,
    'wrongCount': wrongCount,
    'finishedAt': finishedAt.toIso8601String(),
    'instantCheck': instantCheck,
  };

  static GameRecord fromJson(Map<String, dynamic> json) => GameRecord(
    difficulty: Difficulty.values.byName(json['difficulty'] as String),
    elapsedSeconds: json['elapsedSeconds'] as int,
    wrongCount: json['wrongCount'] as int,
    finishedAt: DateTime.parse(json['finishedAt'] as String),
    instantCheck: json['instantCheck'] as bool? ?? true,
  );
}
