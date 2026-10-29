import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/difficulty.dart';
import '../models/saved_game.dart';

/// 이어하기 카드에 필요한 요약 정보.
@immutable
class SavedGameMeta {
  const SavedGameMeta({
    required this.difficulty,
    required this.filledRatio,
    required this.elapsedMs,
    this.weeklyBoard,
  });

  factory SavedGameMeta.of(SavedGame s) => SavedGameMeta(
    difficulty: s.difficulty,
    filledRatio: s.filledRatio,
    elapsedMs: s.elapsedMs,
    weeklyBoard: s.weeklyBoard,
  );

  final Difficulty difficulty;
  final double filledRatio;
  final int elapsedMs;

  /// 주간 판이면 보드 ID.
  final String? weeklyBoard;
}

sealed class LoadResult {
  const LoadResult();
}

final class LoadNone extends LoadResult {
  const LoadNone();
}

final class LoadOk extends LoadResult {
  const LoadOk(this.game);
  final SavedGame game;
}

final class LoadIncompatible extends LoadResult {
  const LoadIncompatible();
}

/// 진행 중인 판 1슬롯 저장소.
class GameSaveStore {
  static const _key = 'sudoku_jang_save_v1';

  GameSaveStore(this._prefs) {
    final r = _read();
    meta.value = r is LoadOk ? SavedGameMeta.of(r.game) : null;
  }

  final SharedPreferences _prefs;
  final ValueNotifier<SavedGameMeta?> meta = ValueNotifier(null);

  LoadResult load() {
    final r = _read();
    if (r is LoadIncompatible) {
      // 비동기 삭제지만 meta 는 즉시 갱신한다.
      clear();
    }
    return r;
  }

  /// write/clear 순서 보장용. 늦게 끝난 write 가 clear 를 덮지 않게 한다.
  int _generation = 0;

  Future<void> write(SavedGame game) async {
    final gen = ++_generation;
    final m = SavedGameMeta.of(game);
    try {
      await _prefs.setString(_key, jsonEncode(game.toJson()));
    } catch (e) {
      debugPrint('GameSaveStore: 저장 실패 ($e)');
    }
    // GameScreen.initState(빌드 중)에서 불리므로 알림은 await 뒤에 보낸다.
    // 동기로 알리면 아래에 깔린 홈의 이어하기 카드가 빌드 중 setState 를 한다.
    if (gen == _generation) meta.value = m;
  }

  Future<void> clear() async {
    _generation++;
    meta.value = null;
    try {
      await _prefs.remove(_key);
    } catch (e) {
      debugPrint('GameSaveStore: 삭제 실패 ($e)');
    }
  }

  LoadResult _read() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const LoadNone();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const LoadIncompatible();
      final game = SavedGame.tryFromJson(decoded);
      return game == null ? const LoadIncompatible() : LoadOk(game);
    } catch (_) {
      return const LoadIncompatible();
    }
  }
}
