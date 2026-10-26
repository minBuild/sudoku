import 'package:flutter/widgets.dart';

Locale _normalize(Locale l) => switch (l) {
  Locale(languageCode: 'no') => Locale.fromSubtags(
    languageCode: 'nb',
    countryCode: l.countryCode,
  ),
  Locale(
    languageCode: 'zh',
    scriptCode: null,
    countryCode: 'TW' || 'HK' || 'MO',
  ) =>
    Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: l.countryCode,
    ),
  _ => l,
};

/// 기기 선호 언어 목록 → 지원 언어. 미지원이면 supported.first(en).
Locale resolveAppLocale(List<Locale>? locales, Iterable<Locale> supported) =>
    basicLocaleListResolution(locales?.map(_normalize).toList(), supported);
