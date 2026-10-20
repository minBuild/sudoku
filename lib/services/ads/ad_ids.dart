import 'package:flutter/foundation.dart';

/// 전면광고 단위 ID.
///
/// 디버그 빌드는 Google 샘플 동영상 전면광고, 릴리스 빌드는
/// `--dart-define-from-file=config/ads.release.json` 값을 쓴다.
abstract final class AdIds {
  static const _androidRelease = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ANDROID',
  );
  static const _iosRelease = String.fromEnvironment('ADMOB_INTERSTITIAL_IOS');
  static const _testDevices = String.fromEnvironment('ADMOB_TEST_DEVICES');

  static const _androidSample = 'ca-app-pub-3940256099942544/8691691433';
  static const _iosSample = 'ca-app-pub-3940256099942544/5135589807';

  /// 비어 있으면 null (광고는 skipped).
  static String? get interstitial {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    if (kDebugMode) return isIos ? _iosSample : _androidSample;
    final id = isIos ? _iosRelease : _androidRelease;
    if (id.isEmpty) {
      debugPrint('AdIds: 전면광고 단위 ID 없음 → 광고를 건너뜁니다');
      return null;
    }
    return id;
  }

  static List<String> get testDeviceIds => _testDevices
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}
