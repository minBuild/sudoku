import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/legal_links.dart';

void main() {
  test('개인정보처리방침 URL 은 https 이고 TODO_ 가 없다', () {
    expect(privacyPolicyUrl, startsWith('https://'));
    expect(privacyPolicyUrl, isNot(contains('TODO_')));
  }, skip: privacyPolicyUrl.isEmpty ? '방침 미호스팅' : false);
}
