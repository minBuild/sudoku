import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/weekly/ranking_policy.dart';

// firebase/firestore.rules 의 Dart 미러 (W9).
void main() {
  test('기록이 없거나 더 빠르면 쓰고, 같거나 느리면 쓰지 않는다', () {
    expect(RankingPolicy.shouldWrite(existingMs: null, newMs: 60000), isTrue);
    expect(RankingPolicy.shouldWrite(existingMs: 60000, newMs: 59999), isTrue);
    expect(RankingPolicy.shouldWrite(existingMs: 60000, newMs: 60000), isFalse);
    expect(RankingPolicy.shouldWrite(existingMs: 60000, newMs: 70000), isFalse);
  });

  test('ms 경계 9999 / 10000 / 86400000 / 86400001', () {
    expect(RankingPolicy.validMs(9999), isFalse);
    expect(RankingPolicy.validMs(10000), isTrue);
    expect(RankingPolicy.validMs(86400000), isTrue);
    expect(RankingPolicy.validMs(86400001), isFalse);
    expect(RankingPolicy.shouldWrite(existingMs: null, newMs: 9999), isFalse);
    expect(
      RankingPolicy.shouldWrite(existingMs: null, newMs: 86400001),
      isFalse,
    );
  });

  test('nick·updatedAt 만 바꾸는 update 는 허용, ms 를 바꾸면 아님', () {
    final before = {'ms': 60000, 'nick': 'a', 'updatedAt': 1, 'v': 1};
    expect(
      RankingPolicy.nickOnlyUpdateAllowed(before, {
        ...before,
        'nick': 'bb',
        'updatedAt': 2,
      }),
      isTrue,
    );
    expect(
      RankingPolicy.nickOnlyUpdateAllowed(before, {...before, 'ms': 70000}),
      isFalse,
    );
    expect(
      RankingPolicy.nickOnlyUpdateAllowed(before, {...before, 'extra': true}),
      isFalse,
    );
  });

  test('isRank1', () {
    expect(RankingPolicy.isRank1(topUid: 'me', myUid: 'me'), isTrue);
    expect(RankingPolicy.isRank1(topUid: 'you', myUid: 'me'), isFalse);
    expect(RankingPolicy.isRank1(topUid: null, myUid: 'me'), isFalse);
    expect(RankingPolicy.maxServerNick, 48);
  });
}
