import 'difficulty.dart';

class GameRecord {
  final Difficulty difficulty;
  final int elapsedSeconds;
  final int wrongCount;
  final DateTime finishedAt;

  GameRecord({
    required this.difficulty,
    required this.elapsedSeconds,
    required this.wrongCount,
    required this.finishedAt,
  });

  Map<String, dynamic> toJson() => {
    'difficulty': difficulty.name,
    'elapsedSeconds': elapsedSeconds,
    'wrongCount': wrongCount,
    'finishedAt': finishedAt.toIso8601String(),
  };

  static GameRecord fromJson(Map<String, dynamic> json) => GameRecord(
    difficulty: Difficulty.values.byName(json['difficulty'] as String),
    elapsedSeconds: json['elapsedSeconds'] as int,
    wrongCount: json['wrongCount'] as int,
    finishedAt: DateTime.parse(json['finishedAt'] as String),
  );
}
