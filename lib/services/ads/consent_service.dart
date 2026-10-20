import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// UMP 동의. 예외는 모두 삼키고 로그만 남긴다.
class ConsentService {
  bool _privacyOptionsRequired = false;

  bool get privacyOptionsRequired => _privacyOptionsRequired;

  /// 동의 정보 갱신 → 필요하면 동의 양식 표시.
  Future<void> gather() async {
    try {
      final updated = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () => updated.complete(),
        (e) {
          debugPrint('UMP update 실패: ${e.errorCode} ${e.message}');
          updated.complete();
        },
      );
      await updated.future;

      final dismissed = Completer<void>();
      await ConsentForm.loadAndShowConsentFormIfRequired((e) {
        if (e != null) debugPrint('UMP form: ${e.errorCode} ${e.message}');
        if (!dismissed.isCompleted) dismissed.complete();
      });
      await dismissed.future;

      _privacyOptionsRequired =
          await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } catch (e) {
      debugPrint('UMP 오류: $e');
    }
  }

  Future<bool> canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
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
