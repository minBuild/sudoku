import 'difficulty.dart';

class GameRecord {
  final Difficulty difficulty;
  final int elapsedSeconds;
  final int wrongCount;
  final DateTime finishedAt;

  /// 즉시 체크를 한 번도 끄지 않고 깬 판인지.
  final bool instantCheck;

  /// 쓴 힌트 수. 1 이상이면 최고 기록에서 뺀다.
  final int hintsUsed;

  GameRecord({
    required this.difficulty,
    required this.elapsedSeconds,
    required this.wrongCount,
    required this.finishedAt,
    this.instantCheck = true,
    this.hintsUsed = 0,
  });

  Map<String, dynamic> toJson() => {
    'difficulty': difficulty.name,
    'elapsedSeconds': elapsedSeconds,
    'wrongCount': wrongCount,
    'finishedAt': finishedAt.toIso8601String(),
    'instantCheck': instantCheck,
    'hintsUsed': hintsUsed,
  };

  static GameRecord fromJson(Map<String, dynamic> json) => GameRecord(
    difficulty: Difficulty.values.byName(json['difficulty'] as String),
    elapsedSeconds: json['elapsedSeconds'] as int,
    wrongCount: json['wrongCount'] as int,
    finishedAt: DateTime.parse(json['finishedAt'] as String),
    instantCheck: json['instantCheck'] as bool? ?? true,
    hintsUsed: json['hintsUsed'] as int? ?? 0,
  );
}
