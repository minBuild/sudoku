import 'package:flutter/foundation.dart';

/// 전면광고 단위 ID. 디버그·프로필은 Google 샘플.
/// 릴리스는 --dart-define(형식이 맞을 때만) → 없으면 아래 기본값. README §광고 ID 위치
abstract final class AdIds {
  static const _androidEnv = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ANDROID',
  );
  static const _iosEnv = String.fromEnvironment('ADMOB_INTERSTITIAL_IOS');
  static const _testDevices = String.fromEnvironment('ADMOB_TEST_DEVICES');

  static const androidSample = 'ca-app-pub-3940256099942544/8691691433';
  static const iosSample = 'ca-app-pub-3940256099942544/5135589807';

  /// AdMob 앱 미등록 → '' (릴리스 Android 는 skipped).
  static const androidProd = '';

  /// iOS 전면광고 단위 sudoku_pregame_interstitial_ios. README §광고 ID 위치
  static const iosProd = 'ca-app-pub-7432278320907197/4247876859';

  @visibleForTesting
  static final unitRe = RegExp(r'^ca-app-pub-\d{16}/\d{10}$');

  /// '' 는 "ID 없음".
  @visibleForTesting
  static String resolve({
    required bool release,
    required bool ios,
    String env = '',
  }) {
    if (!release) return ios ? iosSample : androidSample;
    if (env.isNotEmpty) {
      if (unitRe.hasMatch(env)) return env;
      debugPrint('AdIds: dart-define 단위 ID 형식 오류 → 기본값 사용');
    }
    return ios ? iosProd : androidProd;
  }

  /// 비어 있으면 null (광고는 skipped).
  static String? get interstitial {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    final id = resolve(
      release: kReleaseMode,
      ios: ios,
      env: ios ? _iosEnv : _androidEnv,
    );
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
