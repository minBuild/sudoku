import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'iso_week.dart';
import 'leaderboard_gateway.dart';
import 'nickname.dart';
import 'ranking_policy.dart';
import 'weekly_board.dart';
import 'weekly_store.dart';

/// 결과 시트의 주간 상태 줄.
sealed class WeeklySubmitState {
  const WeeklySubmitState();
}

final class Sending extends WeeklySubmitState {
  const Sending();
}

/// 이번 주 내 최고 기록. 갱신되지 않았거나 서버가 거부해도 이것을 보여 준다.
final class MyBest extends WeeklySubmitState {
  const MyBest(this.ms);
  final int ms;
}

final class Rank1 extends WeeklySubmitState {
  const Rank1(this.ms, {required this.needsNick});
  final int ms;
  final bool needsNick;
}

final class HintExcluded extends WeeklySubmitState {
  const HintExcluded();
}

final class LastWeek extends WeeklySubmitState {
  const LastWeek();
}

/// 주간 화면의 보드별 1등 상태.
sealed class LeaderState {
  const LeaderState();
}

final class LeaderLoading extends LeaderState {
  const LeaderLoading();
}

final class LeaderEmpty extends LeaderState {
  const LeaderEmpty();
}

final class Leader extends LeaderState {
  const Leader(this.entry, {required this.isMe});
  final LeaderEntry entry;
  final bool isMe;
}

final class LeaderFailed extends LeaderState {
  const LeaderFailed();
}

/// 주간 대결. 게임 경로에서는 await 하지 않는다 (W10). BuildContext 없음.
class WeeklyService {
  WeeklyService(this.store, this._lb, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const leaderCacheTtl = Duration(seconds: 60);

  final WeeklyStore store;
  final LeaderboardGateway _lb;
  final DateTime Function() _now;

  /// 보드 ID → 1등 상태. [loadLeaders] 가 채운다.
  final ValueNotifier<Map<String, LeaderState>> leaders = ValueNotifier({});

  String? _uid;
  DateTime? _loadedAt;
  String? _loadedWeek;
  Future<void>? _loading;
  bool _flushing = false;

  /// 마지막으로 확인한 내 익명 uid.
  String? get uid => _uid;

  /// 주입된 시계의 현재 시각.
  DateTime get now => _now();

  List<WeeklyBoard> get boards => WeeklyBoard.current(_now());

  String get weekKey => isoWeekKey(_now());

  /// 클리어 직후. 결과 시트가 바로 그릴 수 있게 즉시 상태를 돌려주고 제출은 뒤에서 한다.
  ValueListenable<WeeklySubmitState> onCleared({
    required String board,
    required int ms,
    required int hintsUsed,
  }) {
    if (hintsUsed > 0) return ValueNotifier(const HintExcluded());
    final b = WeeklyBoard.parse(board);
    if (b == null || b.weekKey != isoWeekKey(_now())) {
      return ValueNotifier(const LastWeek());
    }
    if (!RankingPolicy.validMs(ms)) {
      unawaited(store.recordClear(board, ms));
      return ValueNotifier(MyBest(ms));
    }
    final out = ValueNotifier<WeeklySubmitState>(const Sending());
    unawaited(() async {
      await store.recordClear(board, ms);
      await store.addPending(board, ms);
      await _submit(board, out);
    }());
    return out;
  }

  /// 서버 읽기 → [RankingPolicy] → 쓰기 (W8). 실패하면 pending 에 남기고 [Sending] 을 유지한다.
  Future<void> _submit(
    String board, [
    ValueNotifier<WeeklySubmitState>? out,
  ]) async {
    final ms = store.pending[board];
    if (ms == null) return;
    final u = await _lb.ensureUser();
    if (u is! LbOk<String>) return;
    final uid = _uid = u.value;
    final m = await _lb.mine(board, uid);
    if (m is! LbOk<LeaderEntry?>) return;
    final existing = m.value;
    final nick = store.nick;
    if (RankingPolicy.shouldWrite(existingMs: existing?.ms, newMs: ms)) {
      final w = await _lb.write(board, uid, ms: ms, nick: nick ?? '');
      if (w is! LbOk) return;
    } else if (existing != null && nick != null && existing.nick != nick) {
      await _lb.updateNick(board, uid, nick); // 실패는 무시한다.
    }
    await store.removePending(board);
    _loadedAt = null;

    final best = existing == null ? ms : min(ms, existing.ms);
    final t = await _lb.top(board);
    if (out == null) return;
    if (t is LbOk<LeaderEntry?> &&
        RankingPolicy.isRank1(topUid: t.value?.uid, myUid: uid)) {
      out.value = Rank1(t.value!.ms, needsNick: store.nick == null);
    } else {
      out.value = MyBest(best);
    }
  }

  /// 미전송 기록을 주차와 무관하게 모두 보낸다 (W24).
  Future<void> flushPending() async {
    if (_flushing) return;
    _flushing = true;
    try {
      for (final board in store.pending.keys.toList()) {
        await _submit(board);
      }
    } finally {
      _flushing = false;
    }
  }

  /// 이번 주 5개 보드의 1등. [leaderCacheTtl] 동안은 다시 읽지 않는다.
  Future<void> loadLeaders({bool force = false}) {
    final wk = weekKey;
    final at = _loadedAt;
    final fresh =
        at != null &&
        _loadedWeek == wk &&
        _now().difference(at) < leaderCacheTtl &&
        !_now().isBefore(at);
    if (!force && fresh) return Future.value();
    return _loading ??= _load(wk).whenComplete(() => _loading = null);
  }

  Future<void> _load(String wk) async {
    final ids = [for (final b in WeeklyBoard.current(_now())) b.id];
    leaders.value = {for (final id in ids) id: const LeaderLoading()};
    final u = await _lb.ensureUser();
    if (u is! LbOk<String>) {
      leaders.value = {for (final id in ids) id: const LeaderFailed()};
      return;
    }
    final uid = _uid = u.value;
    final results = await Future.wait(ids.map(_lb.top));
    final next = <String, LeaderState>{};
    var allOk = true;
    for (var i = 0; i < ids.length; i++) {
      next[ids[i]] = switch (results[i]) {
        LbOk(value: final e?) => Leader(e, isMe: e.uid == uid),
        LbOk() => const LeaderEmpty(),
        LbFail() => const LeaderFailed(),
      };
      if (results[i] is LbFail) allOk = false;
    }
    leaders.value = next;
    if (allOk) {
      _loadedAt = _now();
      _loadedWeek = wk;
    }
  }

  @visibleForTesting
  Future<void>? lastNickSync;

  /// 검증 → 로컬 저장 → 이번 주 기록이 있는 보드에 반영(뒤에서). 통과하면 null.
  Future<NicknameError?> setNickname(String raw) async {
    final err = Nickname.validate(raw);
    if (err != null) return err;
    final nick = Nickname.normalize(raw);
    await store.setNick(nick);
    final boards = store.clearedBoards(weekKey).toList();
    lastNickSync = () async {
      final u = await _lb.ensureUser();
      if (u is! LbOk<String>) return;
      _uid = u.value;
      for (final b in boards) {
        await _lb.updateNick(b, u.value, nick);
      }
      _loadedAt = null;
    }();
    unawaited(lastNickSync);
    _loadedAt = null;
    return null;
  }
}
