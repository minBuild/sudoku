import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/models/difficulty.dart';
import 'package:sudoku/services/weekly/weekly_board.dart';
import 'package:sudoku/services/weekly/weekly_service.dart';
import 'package:sudoku/services/weekly/weekly_store.dart';

import '../../fakes.dart';

Future<void> _settle() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late SharedPreferences prefs;
  late FakeLeaderboard lb;
  late DateTime now;
  late WeeklyStore store;
  late WeeklyService svc;

  const board = WeeklyBoard('2026-W44', Difficulty.hard);
  final id = board.id;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    lb = FakeLeaderboard();
    now = DateTime.utc(2026, 10, 29, 3);
    store = WeeklyStore(prefs, now: () => now);
    svc = WeeklyService(store, lb, now: () => now);
  });

  Future<WeeklySubmitState> clear(int ms, {int hints = 0, String? b}) async {
    final s = svc.onCleared(board: b ?? id, ms: ms, hintsUsed: hints);
    await _settle();
    return s.value;
  }

  test('힌트 판이면 HintExcluded, 네트워크 0', () async {
    expect(await clear(60000, hints: 1), isA<HintExcluded>());
    expect(lb.calls, 0);
    expect(store.pending, isEmpty);
  });

  test('지난 주 보드면 LastWeek, 제출 없음', () async {
    final s = await clear(60000, b: '2026-W43_hard_g1');
    expect(s, isA<LastWeek>());
    expect(lb.calls, 0);
  });

  test('범위 밖 ms 는 로컬에만 남기고 MyBest', () async {
    final s = await clear(5000);
    expect(s, isA<MyBest>().having((m) => m.ms, 'ms', 5000));
    expect(lb.calls, 0);
    expect(store.bestOf(id), 5000);
  });

  test('오프라인이면 Sending + pending 1건 → 온라인 flush 후 pending 0, 서버 1건', () async {
    lb.offline = true;
    final notifier = svc.onCleared(board: id, ms: 60000, hintsUsed: 0);
    expect(notifier.value, isA<Sending>()); // 즉시
    await _settle();
    expect(notifier.value, isA<Sending>());
    expect(store.pending, {id: 60000});

    lb.offline = false;
    await svc.flushPending();
    expect(store.pending, isEmpty);
    expect(lb.boards[id]!.length, 1);
    expect(lb.boards[id]!['me']!.ms, 60000);
  });

  test('서버 기록보다 느리면 쓰지 않고 MyBest(서버값)', () async {
    lb.seed(id, 'me', 50000);
    lb.seed(id, 'other', 40000);
    final s = await clear(70000);
    expect(lb.writeCalls, 0);
    expect(s, isA<MyBest>().having((m) => m.ms, 'ms', 50000));
    expect(store.pending, isEmpty);
  });

  test('같은 ms 재전송은 쓰기 없이 pending 만 지운다', () async {
    lb.seed(id, 'me', 60000);
    await store.addPending(id, 60000);
    await svc.flushPending();
    expect(lb.writeCalls, 0);
    expect(store.pending, isEmpty);
  });

  test('내가 top 이고 닉네임이 없으면 Rank1(needsNick)', () async {
    lb.seed(id, 'other', 90000);
    final s = await clear(60000);
    expect(
      s,
      isA<Rank1>()
          .having((r) => r.needsNick, 'needsNick', isTrue)
          .having((r) => r.ms, 'ms', 60000),
    );
  });

  test('저장된 닉네임으로 제출하고 Rank1(needsNick: false)', () async {
    await store.setNick('스도쿠왕');
    final s = await clear(60000);
    expect(lb.boards[id]!['me']!.nick, '스도쿠왕');
    expect(s, isA<Rank1>().having((r) => r.needsNick, 'needsNick', isFalse));
  });

  test('setNickname 은 검증하고 이번 주 기록 보드에 updateNick', () async {
    await clear(60000);
    expect(await svc.setNickname('a'), isNotNull);
    expect(lb.updateNickCalls, 0);

    expect(await svc.setNickname('  홍길동 '), isNull);
    await svc.lastNickSync;
    expect(store.nick, '홍길동');
    expect(lb.updateNickCalls, 1);
    expect(lb.boards[id]!['me']!.nick, '홍길동');
  });

  test('loadLeaders: 60초 캐시, force 면 다시 읽는다, 실패한 보드는 Failed', () async {
    lb.seed(id, 'me', 60000, 'n');
    await svc.loadLeaders();
    expect(lb.topCalls, 5);
    final s = svc.leaders.value[id];
    expect(s, isA<Leader>().having((l) => l.isMe, 'isMe', isTrue));
    expect(
      svc.leaders.value['2026-W44_easy_g1'] ??
          svc.leaders.value[WeeklyBoard('2026-W44', Difficulty.easy).id],
      isA<LeaderEmpty>(),
    );

    now = now.add(const Duration(seconds: 30));
    await svc.loadLeaders();
    expect(lb.topCalls, 5);
    await svc.loadLeaders(force: true);
    expect(lb.topCalls, 10);
    now = now.add(const Duration(seconds: 61));
    await svc.loadLeaders();
    expect(lb.topCalls, 15);

    lb.offline = true;
    await svc.loadLeaders(force: true);
    expect(svc.leaders.value.values, everyElement(isA<LeaderFailed>()));
  });

  test('onCleared 의 반환값은 ValueListenable', () {
    expect(
      svc.onCleared(board: id, ms: 60000, hintsUsed: 1),
      isA<ValueListenable<WeeklySubmitState>>(),
    );
  });
}
