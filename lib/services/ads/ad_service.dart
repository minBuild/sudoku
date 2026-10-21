import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';
import 'consent_service.dart';
import 'tracking_authorization.dart';

enum AdOutcome { shown, skipped, failed }

enum AdPhase { idle, loading, showing }

abstract interface class AdGateway {
  /// consent → initialize → preload. throw 하지 않는다.
  Future<void> warmUp();

  /// 새 퍼즐 시작 전 전면광고. throw 하지 않는다.
  Future<AdOutcome> showPreGameAd();

  /// phase 가 loading 일 때만 skipped 로 완료. showing 이면 no-op (D4).
  void cancelPending();

  /// 캐시를 dispose 하고 이후 모든 호출을 skipped 로 처리.
  void disable();

  AdPhase get phase;

  /// 설정 화면의 [개인정보 옵션] 노출 여부.
  bool get privacyOptionsRequired;

  Future<void> showPrivacyOptionsForm();
}

class AdPolicy {
  static const minInterval = Duration.zero;
  static const loadWait = Duration(seconds: 3);
  static const showWait = Duration(seconds: 5);
}

class _Session {
  bool cancelled = false;
  final cancel = Completer<AdOutcome>();
}

class AdMobService implements AdGateway {
  AdMobService({
    ConsentService? consent,
    TrackingAuthorization? att,
    DateTime Function()? now,
  }) : _consent = consent ?? ConsentService(),
       _att = att ?? TrackingAuthorization(),
       _now = now ?? DateTime.now;

  final ConsentService _consent;
  final TrackingAuthorization _att;
  final DateTime Function() _now;

  /// 전면광고는 로드 후 1시간이면 만료되므로 여유를 두고 폐기한다.
  static const cacheTtl = Duration(minutes: 50);

  Future<bool>? _init;
  bool _disabled = false;
  AdPhase _phase = AdPhase.idle;
  _Session? _session;
  InterstitialAd? _cached;
  DateTime? _cachedAt;
  Future<InterstitialAd?>? _loading;
  DateTime? _lastShownAt;

  @visibleForTesting
  static bool isExpired(DateTime loadedAt, DateTime now) =>
      now.difference(loadedAt) > cacheTtl;

  /// 만료된 캐시는 dispose 하고 비운 뒤 남은 캐시를 돌려준다.
  InterstitialAd? _fresh() {
    final ad = _cached;
    if (ad != null && isExpired(_cachedAt!, _now())) {
      ad.dispose();
      _cached = null;
      _cachedAt = null;
    }
    return _cached;
  }

  @override
  AdPhase get phase => _phase;

  @override
  bool get privacyOptionsRequired => _consent.privacyOptionsRequired;

  @override
  Future<void> showPrivacyOptionsForm() => _consent.showPrivacyOptionsForm();

  @override
  Future<void> warmUp() async {
    try {
      if (_disabled || _phase != AdPhase.idle) return;
      final ok = await (_init ??= _initialize());
      if (ok && !_disabled) await _preload();
    } catch (e) {
      debugPrint('AdMobService.warmUp 오류: $e');
    }
  }

  Future<bool> _initialize() async {
    try {
      await _consent.gather();
      await _att.requestIfNeeded();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: AdIds.testDeviceIds),
      );
      await MobileAds.instance.initialize();
      return await _consent.canRequestAds();
    } catch (e) {
      debugPrint('AdMobService 초기화 오류: $e');
      return false;
    }
  }

  @override
  Future<AdOutcome> showPreGameAd() async {
    final unitId = AdIds.interstitial;
    final last = _lastShownAt;
    if (_disabled ||
        _phase != AdPhase.idle ||
        unitId == null ||
        (last != null &&
            DateTime.now().difference(last) < AdPolicy.minInterval)) {
      return AdOutcome.skipped;
    }

    final session = _Session();
    _session = session;
    _phase = AdPhase.loading;
    try {
      return await Future.any([_loadAndShow(session), session.cancel.future]);
    } catch (e) {
      debugPrint('AdMobService.showPreGameAd 오류: $e');
      return AdOutcome.failed;
    } finally {
      if (identical(_session, session)) {
        _session = null;
        _phase = AdPhase.idle;
      }
      if (!_disabled) unawaited(_preload());
    }
  }

  Future<AdOutcome> _loadAndShow(_Session session) async {
    final sw = Stopwatch()..start();
    Duration remaining() {
      final r = AdPolicy.loadWait - sw.elapsed;
      return r > Duration.zero ? r : Duration.zero;
    }

    // ① 로드 대기 (초기화 포함 최대 loadWait)
    final ready = await (_init ??= _initialize()).timeout(
      remaining(),
      onTimeout: () => false,
    );
    if (!ready || session.cancelled || _disabled) return AdOutcome.skipped;

    final ad =
        _fresh() ??
        await _preload().timeout(remaining(), onTimeout: () => null);
    if (ad == null) return AdOutcome.skipped;

    final appResumed =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    if (session.cancelled || _disabled || !appResumed) {
      return AdOutcome.skipped; // 광고 객체는 캐시에 남긴다.
    }

    // ② show() 후 showWait 안에 표시돼야 한다.
    _cached = null;
    _cachedAt = null;
    final showed = Completer<bool>();
    final result = Completer<AdOutcome>();
    void finish(AdOutcome o) {
      if (!showed.isCompleted) showed.complete(false);
      if (!result.isCompleted) result.complete(o);
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {
        if (!showed.isCompleted) showed.complete(true);
      },
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        finish(AdOutcome.shown);
      },
      onAdFailedToShowFullScreenContent: (a, e) {
        debugPrint('전면광고 표시 실패: ${e.code} ${e.message}');
        a.dispose();
        finish(AdOutcome.failed);
      },
    );
    _phase = AdPhase.showing;
    try {
      await ad.show();
    } catch (e) {
      debugPrint('전면광고 show 오류: $e');
      ad.dispose();
      return AdOutcome.failed;
    }

    final didShow = await showed.future.timeout(
      AdPolicy.showWait,
      onTimeout: () => false,
    );
    if (!didShow) {
      if (!result.isCompleted) {
        ad.dispose();
        finish(AdOutcome.failed);
      }
      return result.future;
    }
    _lastShownAt = DateTime.now();

    // ③ 표시된 뒤에는 타임아웃 없이 콜백만 기다린다.
    return result.future;
  }

  Future<InterstitialAd?> _preload() {
    final cached = _fresh();
    if (cached != null) return Future.value(cached);
    final unitId = AdIds.interstitial;
    if (_disabled || unitId == null || _init == null) return Future.value();
    return _loading ??= _load(unitId).whenComplete(() => _loading = null);
  }

  Future<InterstitialAd?> _load(String unitId) async {
    if (!await _init!) return null;
    final c = Completer<InterstitialAd?>();
    try {
      await InterstitialAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            if (_disabled) {
              ad.dispose();
              c.complete(null);
            } else {
              _cached = ad;
              _cachedAt = _now();
              c.complete(ad);
            }
          },
          onAdFailedToLoad: (e) {
            debugPrint('전면광고 로드 실패: ${e.code} ${e.message}');
            c.complete(null);
          },
        ),
      );
    } catch (e) {
      debugPrint('전면광고 load 오류: $e');
      if (!c.isCompleted) c.complete(null);
    }
    return c.future;
  }

  @override
  void cancelPending() {
    final s = _session;
    if (s == null || _phase != AdPhase.loading) return;
    s.cancelled = true;
    if (!s.cancel.isCompleted) s.cancel.complete(AdOutcome.skipped);
  }

  @override
  void disable() {
    if (_disabled) return;
    cancelPending();
    _disabled = true;
    _cached?.dispose();
    _cached = null;
    _cachedAt = null;
  }
}
