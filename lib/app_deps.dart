import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/difficulty.dart';
import 'models/sudoku_puzzle.dart';
import 'services/ads/ad_service.dart';
import 'services/game_save_store.dart';
import 'services/purchase/entitlement_store.dart';
import 'services/purchase/purchase_service.dart';
import 'services/record_store.dart';
import 'services/settings_store.dart';
import 'services/sudoku_generator.dart';

typedef PuzzleFactory = Future<SudokuPuzzle> Function(Difficulty);

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
  });

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
}
