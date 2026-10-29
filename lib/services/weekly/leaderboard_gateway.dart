/// 리더보드 호출 결과. 게이트웨이는 throw 하지 않고 이것만 돌려준다 (W10).
sealed class LbResult<T> {
  const LbResult();
}

final class LbOk<T> extends LbResult<T> {
  const LbOk(this.value);
  final T value;
}

final class LbFail<T> extends LbResult<T> {
  const LbFail();
}

class LeaderEntry {
  const LeaderEntry({required this.uid, required this.ms, required this.nick});

  final String uid;
  final int ms;

  /// 서버 값. '' 이면 화면에는 "익명".
  final String nick;
}

/// 모든 메서드는 throw 하지 않고 5초 timeout 을 둔다.
abstract interface class LeaderboardGateway {
  static const timeout = Duration(seconds: 5);

  /// 익명 uid.
  Future<LbResult<String>> ensureUser();

  Future<LbResult<LeaderEntry?>> mine(String board, String uid);

  Future<LbResult<LeaderEntry?>> top(String board);

  Future<LbResult<void>> write(
    String board,
    String uid, {
    required int ms,
    required String nick,
  });

  Future<LbResult<void>> updateNick(String board, String uid, String nick);
}

/// Firebase 설정이 없을 때. 모든 호출이 실패한다.
class DisabledLeaderboard implements LeaderboardGateway {
  const DisabledLeaderboard();

  @override
  Future<LbResult<String>> ensureUser() async => const LbFail();

  @override
  Future<LbResult<LeaderEntry?>> mine(String board, String uid) async =>
      const LbFail();

  @override
  Future<LbResult<LeaderEntry?>> top(String board) async => const LbFail();

  @override
  Future<LbResult<void>> write(
    String board,
    String uid, {
    required int ms,
    required String nick,
  }) async => const LbFail();

  @override
  Future<LbResult<void>> updateNick(
    String board,
    String uid,
    String nick,
  ) async => const LbFail();
}
