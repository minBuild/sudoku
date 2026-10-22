/// UI 문자열 접근점. 문구는 `app_*.arb` 에 두고 `flutter pub get` 으로 생성한다.
///
/// 가격 숫자는 넣지 않는다 — 가격은 `ProductDetails.price` 만 표시.
library;

import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
