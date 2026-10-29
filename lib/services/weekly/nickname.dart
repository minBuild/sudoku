import 'package:characters/characters.dart';

import 'ranking_policy.dart';

enum NicknameError { tooShort, tooLong, invalidChars, banned }

/// 공개 닉네임 검증 (W20). 순서: 정리 → 길이 → 허용 문자 → 금칙어.
abstract final class Nickname {
  static const minLength = 2;
  static const maxLength = 12;

  // ZW(200B~200D, FEFF)·bidi 제어(202A~202E, 2066~2069).
  static bool _invisible(int r) =>
      (r >= 0x200B && r <= 0x200D) ||
      r == 0xFEFF ||
      (r >= 0x202A && r <= 0x202E) ||
      (r >= 0x2066 && r <= 0x2069);

  static final _spaces = RegExp(r'\s+');

  // \p{M}: th·hi 는 결합 문자(모음·성조·virama)가 필수다. 첫 글자로는 받지 않는다.
  static final _allowed = RegExp(
    r'^[\p{L}\p{N}_][\p{L}\p{M}\p{N} _]*$',
    unicode: true,
  );

  /// 토큰이나 구분자를 뺀 전체와 정확히 같으면 금지. 정상어와 겹치는 말은 여기에만 둔다.
  static const _exact = {
    'admin',
    'administrator',
    'moderator',
    'operator',
    'system',
    'anonymous',
    '운영자',
    '관리자',
    '익명',
    '시발',
    '시바',
    'shit',
    'bitch',
    'cunt',
    'ass',
    'asshole',
    'dick',
    'pussy',
    'sex',
    'porn',
    'nazi',
    'hitler',
    '섹스',
    '애미',
    '느금마',
  };

  /// 어디에 들어 있어도 금지하는 강한 욕설. 오탐(Scunthorpe·Classic)이 없는 말만 둔다.
  static const _contains = {
    'fuck',
    'nigger',
    'nigga',
    'faggot',
    '씨발',
    '씨팔',
    '좆',
    '병신',
    '개새끼',
  };

  static const _leet = {
    '0': 'o',
    '1': 'i',
    '3': 'e',
    '4': 'a',
    '5': 's',
    '7': 't',
  };

  /// 보이지 않는 제어문자 제거 → trim → 연속 공백 1개로.
  static String normalize(String s) => String.fromCharCodes(
    s.runes.where((r) => !_invisible(r)),
  ).trim().replaceAll(_spaces, ' ');

  /// 통과하면 null.
  static NicknameError? validate(String raw) {
    final s = normalize(raw);
    final n = s.characters.length;
    if (n < minLength) return NicknameError.tooShort;
    if (n > maxLength || s.length > RankingPolicy.maxServerNick) {
      return NicknameError.tooLong;
    }
    if (!_allowed.hasMatch(s)) return NicknameError.invalidChars;
    if (_isBanned(s)) return NicknameError.banned;
    return null;
  }

  static bool _isBanned(String s) {
    final folded = String.fromCharCodes(
      s.toLowerCase().runes.map(
        // 전각 ASCII(FF01~FF5E) → 반각.
        (r) => r >= 0xFF01 && r <= 0xFF5E ? r - 0xFEE0 : r,
      ),
    ).toLowerCase();
    final plain = folded.split('').map((ch) => _leet[ch] ?? ch).join();
    final tokens = plain.split(RegExp(r'[ _]+')).where((t) => t.isNotEmpty);
    final compact = plain.replaceAll(RegExp(r'[ _]+'), '');
    if (_exact.contains(compact) || tokens.any(_exact.contains)) return true;
    return _contains.any(compact.contains);
  }
}
