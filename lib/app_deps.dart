import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/difficulty.dart';
import 'models/sudoku_puzzle.dart';
import 'services/ads/ad_schedule.dart';
import 'services/ads/ad_service.dart';
import 'services/game_save_store.dart';
import 'services/legal_links.dart';
import 'services/purchase/entitlement_store.dart';
import 'services/purchase/purchase_service.dart';
import 'services/record_store.dart';
import 'services/settings_store.dart';
import 'services/sound/sound_service.dart';
import 'services/sudoku_generator.dart';

typedef PuzzleFactory = Future<SudokuPuzzle> Function(Difficulty);
typedef UrlOpener = Future<bool> Function(Uri);

Future<bool> _neverOpens(Uri _) async => false;

/// 외부 브라우저로 연다. launchUrl 은 실패 시 false 대신 예외를 던지기도 한다
/// (Android ACTIVITY_NOT_FOUND, iOS argument_error).
Future<bool> launchExternal(Uri u) async {
  try {
    return await launchUrl(u, mode: LaunchMode.externalApplication);
  } on Exception catch (e) {
    debugPrint('openUrl 실패: $e');
    return false;
  }
}

/// 앱 전역 의존성. 테스트에서는 생성자로 가짜를 주입한다 (D23).
class AppDeps {
  AppDeps({
    required this.prefs,
    required this.entitlement,
    required this.purchase,
    required this.ads,
    required this.records,
    required this.settings,
    required this.saves,
    required this.generate,
    AdSchedule? adSchedule,
    UrlOpener? openUrl,
    this.privacyPolicyUri,
    SoundGateway? sound,
  }) : adSchedule = adSchedule ?? AdSchedule(),
       openUrl = openUrl ?? _neverOpens,
       sound = sound ?? const NoopSoundService();

  /// entitlement 동기 로드 + purchase 스트림 동기 구독 (D13).
  factory AppDeps.production(SharedPreferences prefs) {
    final entitlement = EntitlementStore(prefs);
    final purchase = PurchaseService(entitlement)..listen();
    final ads = AdMobService();
    if (entitlement.adsRemoved.value) ads.disable();
    entitlement.adsRemoved.addListener(() {
      if (entitlement.adsRemoved.value) ads.disable();
    });
    return AppDeps(
      prefs: prefs,
      entitlement: entitlement,
      purchase: purchase,
      ads: ads,
      records: RecordStore(prefs),
      settings: SettingsStore(prefs),
      saves: GameSaveStore(prefs),
      generate: (d) => compute(generatePuzzle, d),
      openUrl: launchExternal,
      privacyPolicyUri: privacyPolicyUrl.isEmpty
          ? null
          : Uri.parse(privacyPolicyUrl),
      sound: AudioPlayersSoundService(),
    );
  }

  final SharedPreferences prefs;
  final EntitlementStore entitlement;
  final PurchaseGateway purchase;
  final AdGateway ads;
  final RecordStore records;
  final SettingsStore settings;
  final GameSaveStore? saves;
  final PuzzleFactory generate;
  final AdSchedule adSchedule;
  final UrlOpener openUrl;

  /// 게임 효과음. 테스트 기본값은 무음.
  final SoundGateway sound;

  /// null 이면 설정의 방침 행을 숨긴다 (호스팅 전).
  final Uri? privacyPolicyUri;
}
