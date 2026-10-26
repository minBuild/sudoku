import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/l10n/l10n.dart';

/// 복수형 분기에 숫자를 직접 써넣은 번역(`one{1 ошибка}` 등)을 잡는다.
/// 어떤 분기로 가든 출력에 그 숫자가 들어 있어야 한다.
const _arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

String _toArabicIndic(int n) =>
    '$n'.split('').map((d) => _arabicIndic[int.parse(d)]).join();

Map<String, String Function(int)> _pluralKeys(AppLocalizations l) => {
  'difficultyRule': l.difficultyRule,
  'gameOverSub': l.gameOverSub,
  'mistakeTimes': l.mistakeTimes,
  'recentRecords': l.recentRecords,
  'recordMistakes': l.recordMistakes,
};

/// n=0 도 확인할 언어 (0 이 one 범주로 가는 언어).
const _zeroLangs = {'fr', 'pt', 'hi'};

void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    final tag = locale.toLanguageTag();
    final ns = [21, 101, if (_zeroLangs.contains(locale.languageCode)) 0];
    test('$tag 복수형 출력에 숫자가 있다 (${ns.join(', ')})', () {
      final l = lookupAppLocalizations(locale);
      for (final MapEntry(key: k, value: f) in _pluralKeys(l).entries) {
        for (final n in ns) {
          final s = f(n);
          expect(
            s.contains('$n') || s.contains(_toArabicIndic(n)),
            isTrue,
            reason: '$tag.$k($n) = $s',
          );
        }
      }
    });
  }
}
