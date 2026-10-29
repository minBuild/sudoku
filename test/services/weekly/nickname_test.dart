import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/weekly/nickname.dart';

void main() {
  NicknameError? v(String s) => Nickname.validate(s);

  group('길이', () {
    test('2자·12자 통과, 1자·13자 실패', () {
      expect(v('ab'), isNull);
      expect(v('a' * 12), isNull);
      expect(v('a'), NicknameError.tooShort);
      expect(v('a' * 13), NicknameError.tooLong);
    });

    test('이모지 1개는 1자 (길이는 통과, 문자에서 걸림)', () {
      expect(v('😀'), NicknameError.tooShort);
      expect(v('a😀'), NicknameError.invalidChars);
    });

    test('ZW·bidi 문자를 지운 뒤 판정하고 앞뒤 공백은 자른다', () {
      final zw = String.fromCharCode(0x200B);
      final rlo = String.fromCharCode(0x202E);
      final bom = String.fromCharCode(0xFEFF);
      final lri = String.fromCharCode(0x2066);
      expect(v('a$zw'), NicknameError.tooShort);
      expect(Nickname.normalize('$rlo a$zw b $bom$lri'), 'a b');
      expect(Nickname.normalize('a$zw$rlo$bom$lri b'), 'a b');
      expect(Nickname.normalize('  홍   길동  '), '홍 길동');
      expect(v('   a   '), NicknameError.tooShort);
      expect(v(' 홍길동 '), isNull);
    });
  });

  group('허용 문자', () {
    test('구두점은 invalid', () {
      expect(v('a-b'), NicknameError.invalidChars);
      expect(v('a.b'), NicknameError.invalidChars);
      expect(v('_ab'), isNull);
      expect(v('a b_c 1'), isNull);
    });

    test('결합 문자가 필요한 th·hi 가 통과한다', () {
      for (final s in ['สวัสดี', 'สมชาย', 'नमस्ते', 'राहुल']) {
        expect(v(s), isNull, reason: s);
      }
    });

    test('ar·he·ko·ja 통과', () {
      for (final s in ['محمد', 'דוד', '스도쿠왕', 'すうどく']) {
        expect(v(s), isNull, reason: s);
      }
    });

    test('첫 글자가 결합 문자면 invalid', () {
      expect(
        v('${String.fromCharCode(0x0E31)}abc'),
        NicknameError.invalidChars,
      );
    });

    test('a + 결합 문자 60개(zalgo)는 tooLong', () {
      final zalgo = 'a${String.fromCharCode(0x0301) * 60}b';
      expect(v(zalgo), NicknameError.tooLong);
    });
  });

  group('금칙어', () {
    test('정확 일치(예약어)', () {
      expect(v('admin'), NicknameError.banned);
      expect(v('ADMIN'), NicknameError.banned);
      expect(v('운영자'), NicknameError.banned);
      expect(v('익명'), NicknameError.banned);
      expect(v('Anonymous'), NicknameError.banned);
      expect(v('시발'), NicknameError.banned);
    });

    test('띄어쓰기·전각·leet 우회도 막는다', () {
      expect(v('F U C K'), NicknameError.banned);
      expect(v('ｆｕｃｋ'), NicknameError.banned);
      expect(v('xFuCkx'), NicknameError.banned);
      expect(v('4dm1n'), NicknameError.banned);
      expect(v('a_d_m_i_n'), NicknameError.banned);
      expect(v('씨발놈'), NicknameError.banned);
    });

    test('오탐 가드: Classic·Assistant·시발점·Scunthorpe 통과', () {
      for (final s in ['Classic', 'Assistant', '시발점', 'Scunthorpe']) {
        expect(v(s), isNull, reason: s);
      }
    });
  });
}
