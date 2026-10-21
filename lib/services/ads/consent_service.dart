import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

typedef LoadAndShowForm =
    Future<void> Function(OnConsentFormDismissedListener listener);

/// UMP 동의. 예외는 모두 삼키고 로그만 남긴다.
class ConsentService {
  ConsentService({ConsentInformation? info, LoadAndShowForm? loadAndShow})
    : _info = info ?? ConsentInformation.instance,
      _loadAndShow =
          loadAndShow ?? ConsentForm.loadAndShowConsentFormIfRequired;

  /// 갱신이 응답하지 않으면 폼을 생략하고 ATT 로 넘어간다 (D7).
  static const updateTimeout = Duration(seconds: 10);

  final ConsentInformation _info;
  final LoadAndShowForm _loadAndShow;
  bool _privacyOptionsRequired = false;

  bool get privacyOptionsRequired => _privacyOptionsRequired;

  /// 동의 정보 갱신 → 필요하면 동의 양식 표시.
  Future<void> gather() async {
    try {
      final updated = Completer<void>();
      _info.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () {
          if (!updated.isCompleted) updated.complete();
        },
        (e) {
          debugPrint('UMP update 실패: ${e.errorCode} ${e.message}');
          if (!updated.isCompleted) updated.complete();
        },
      );
      final ok = await updated.future
          .then((_) => true)
          .timeout(updateTimeout, onTimeout: () => false);
      if (!ok) {
        debugPrint('UMP update timeout → 폼 생략');
        return;
      }

      // 사용자가 입력하는 단계라 타임아웃을 두지 않는다.
      final dismissed = Completer<void>();
      await _loadAndShow((e) {
        if (e != null) debugPrint('UMP form: ${e.errorCode} ${e.message}');
        if (!dismissed.isCompleted) dismissed.complete();
      });
      await dismissed.future;

      _privacyOptionsRequired =
          await _info.getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (e) {
      debugPrint('UMP 오류: $e');
    }
  }

  Future<bool> canRequestAds() async {
    try {
      return await _info.canRequestAds();
    } catch (e) {
      debugPrint('UMP canRequestAds 오류: $e');
      return false;
    }
  }

  Future<void> showPrivacyOptionsForm() async {
    try {
      await ConsentForm.showPrivacyOptionsForm((e) {
        if (e != null) debugPrint('UMP privacy: ${e.errorCode} ${e.message}');
      });
    } catch (e) {
      debugPrint('UMP privacy 오류: $e');
    }
  }
}
