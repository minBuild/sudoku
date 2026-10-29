/// `firebase/firestore.rules` 의 갱신 규칙을 그대로 옮긴 것 (W9).
/// 규칙을 바꾸면 이 파일과 테스트도 함께 바꾼다.
abstract final class RankingPolicy {
  static const minMs = 10000;
  static const maxMs = 86400000;

  /// 서버가 받는 닉네임 UTF-16 길이 상한.
  static const maxServerNick = 48;

  static bool validMs(int ms) => ms >= minMs && ms <= maxMs;

  /// 기록이 없거나 더 빠를 때만 쓴다.
  static bool shouldWrite({required int? existingMs, required int newMs}) =>
      validMs(newMs) && (existingMs == null || newMs < existingMs);

  /// 바뀐 키가 `{nick, updatedAt}` 의 부분집합인지.
  static bool nickOnlyUpdateAllowed(
    Map<String, Object?> before,
    Map<String, Object?> after,
  ) {
    final keys = {...before.keys, ...after.keys};
    final changed = keys.where(
      (k) =>
          before.containsKey(k) != after.containsKey(k) ||
          before[k] != after[k],
    );
    return changed.every((k) => k == 'nick' || k == 'updatedAt');
  }

  static bool isRank1({required String? topUid, required String myUid}) =>
      topUid != null && topUid == myUid;
}
