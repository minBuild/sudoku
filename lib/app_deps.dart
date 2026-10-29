import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';
import 'models/sudoku_puzzle.dart';
import 'services/ads/ad_schedule.dart';
import 'services/ads/ad_service.dart';
import 'services/game_save_store.dart';
import 'services/hint_budget.dart';
import 'services/legal_links.dart';
import 'services/purchase/entitlement_store.dart';
import 'services/purchase/purchase_service.dart';
import 'services/record_store.dart';
import 'services/settings_store.dart';
import 'services/sound/sound_service.dart';
import 'services/sudoku_generator.dart';
import 'services/weekly/firestore_leaderboard.dart';
import 'services/weekly/weekly_puzzle_cache.dart';
import 'services/weekly/weekly_service.dart';
import 'services/weekly/weekly_store.dart';

typedef PuzzleFactory = Future<SudokuPuzzle> Function(PuzzleRequest);
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
    HintBudget? hintBudget,
    this.weekly,
  }) : adSchedule = adSchedule ?? AdSchedule(),
       openUrl = openUrl ?? _neverOpens,
       sound = sound ?? const NoopSoundService(),
       hintBudget = hintBudget ?? HintBudget(prefs);

  /// entitlement 동기 로드 + purchase 스트림 동기 구독 (D13).
  factory AppDeps.production(SharedPreferences prefs) {
    final entitlement = EntitlementStore(prefs);
    final purchase = PurchaseService(entitlement)..listen();
    final ads = AdMobService();
    if (entitlement.adsRemoved.value) ads.disable();
    entitlement.adsRemoved.addListener(() {
      if (entitlement.adsRemoved.value) ads.disable();
    });
    final puzzleCache = WeeklyPuzzleCache(prefs);
    return AppDeps(
      prefs: prefs,
      entitlement: entitlement,
      purchase: purchase,
      ads: ads,
      records: RecordStore(prefs),
      settings: SettingsStore(prefs),
      saves: GameSaveStore(prefs),
      generate: (req) => req.seed == null
          ? compute(generateFor, req)
          : puzzleCache.getOrCreate(req, () => compute(generateFor, req)),
      openUrl: launchExternal,
      privacyPolicyUri: privacyPolicyUrl.isEmpty
          ? null
          : Uri.parse(privacyPolicyUrl),
      sound: AudioPlayersSoundService(),
      // 설정값이 placeholder 면 주간 기능을 숨긴다 (W6).
      weekly: firebaseConfigured
          ? WeeklyService(WeeklyStore(prefs), FirestoreLeaderboard())
          : null,
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

  /// 하루 무료 힌트.
  final HintBudget hintBudget;

  /// 주간 대결. Firebase 설정이 없으면 null 이고 기능을 숨긴다 (W6).
  final WeeklyService? weekly;

  bool get weeklyEnabled => weekly != null;
}
