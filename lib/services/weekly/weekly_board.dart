import '../../models/difficulty.dart';
import '../sudoku_generator.dart';
import 'iso_week.dart';

/// 주차 × 난이도 보드 1개. 서버 문서 경로와 캐시 키에 [id] 를 쓴다 (W1).
class WeeklyBoard {
  const WeeklyBoard(this.weekKey, this.difficulty);

  final String weekKey;
  final Difficulty difficulty;

  static final idRe = RegExp(
    r'^\d{4}-W\d{2}_(easy|normal|hard|expert|hell)_g\d+$',
  );

  String get id => '${weekKey}_${difficulty.name}_g$kGeneratorVersion';

  int get seed => weeklySeed(weekKey, difficulty);

  PuzzleRequest get request =>
      PuzzleRequest(difficulty, seed: seed, weekKey: weekKey);

  /// 형식이 맞지 않으면 null. 생성기 버전은 보존하지 않는다(id 문자열로만 비교).
  static WeeklyBoard? parse(String id) {
    if (!idRe.hasMatch(id)) return null;
    final parts = id.split('_');
    final d = Difficulty.values.asNameMap()[parts[1]];
    return d == null ? null : WeeklyBoard(parts[0], d);
  }

  /// 이번 주의 5개 보드.
  static List<WeeklyBoard> current(DateTime now) {
    final wk = isoWeekKey(now);
    return [for (final d in Difficulty.values) WeeklyBoard(wk, d)];
  }

  @override
  bool operator ==(Object other) =>
      other is WeeklyBoard &&
      other.weekKey == weekKey &&
      other.difficulty == difficulty;

  @override
  int get hashCode => Object.hash(weekKey, difficulty);
}
