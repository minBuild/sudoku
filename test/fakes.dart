import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app_deps.dart';
import 'package:sudoku/l10n/app_localizations.dart';
import 'package:sudoku/models/sudoku_puzzle.dart';
import 'package:sudoku/services/ads/ad_schedule.dart';
import 'package:sudoku/services/ads/ad_service.dart';
import 'package:sudoku/services/game_save_store.dart';
import 'package:sudoku/services/purchase/entitlement_store.dart';
import 'package:sudoku/services/purchase/purchase_service.dart';
import 'package:sudoku/services/record_store.dart';
import 'package:sudoku/services/settings_store.dart';

/// 위젯 테스트 기본 로케일(en_US)의 문구.
final l10nEn = lookupAppLocalizations(const Locale('en'));

/// 유효한 완성판.
List<List<int>> solvedGrid() => List.generate(
  9,
  (r) => List.generate(9, (c) => (r * 3 + r ~/ 3 + c) % 9 + 1),
);

/// [holes] 칸을 비운 퍼즐.
SudokuPuzzle puzzleWithHoles(List<int> holes) {
  final sol = solvedGrid();
  final init = [for (final row in sol) List<int>.from(row)];
  for (final i in holes) {
    init[i ~/ 9][i % 9] = 0;
  }
  return SudokuPuzzle(initial: init, solution: sol);
}

int solAt(int i) => solvedGrid()[i ~/ 9][i % 9];

/// 정답이 아닌 숫자 하나 (solAt(i) + 1). 다 놓인 숫자면 입력이 무시되므로
/// 다음 칸도 빈칸이어야 오답으로 들어간다.
int wrongAt(int i) => solAt(i) % 9 + 1;

class FakeAds implements AdGateway {
  int showCalls = 0;
  int cancelCalls = 0;
  int warmUpCalls = 0;
  bool disabled = false;
  Completer<AdOutcome>? pending;
  Object? throwOnShow;

  /// null 이면 즉시 skipped.
  Completer<AdOutcome> Function()? onShow;

  @override
  AdPhase phase = AdPhase.idle;

  @override
  Future<AdOutcome> showPreGameAd() {
    showCalls++;
    if (throwOnShow != null) return Future.error(throwOnShow!);
    final make = onShow;
    if (make == null) return Future.value(AdOutcome.skipped);
    pending = make();
    return pending!.future;
  }

  @override
  void cancelPending() => cancelCalls++;

  @override
  void disable() => disabled = true;

  @override
  Future<void> warmUp() async => warmUpCalls++;

  @override
  bool privacyOptionsRequired = false;

  @override
  Future<void> showPrivacyOptionsForm() async {}
}

class FakePurchase implements PurchaseGateway {
  FakePurchase([PurchaseUiState initial = const PurchaseLoading()])
    : state = ValueNotifier(initial);

  @override
  final ValueNotifier<PurchaseUiState> state;

  final errorsController = StreamController<PurchaseError>.broadcast();
  int buyCalls = 0;
  int restoreCalls = 0;

  @override
  Stream<PurchaseError> get errors => errorsController.stream;

  @override
  Future<void> buy() async => buyCalls++;

  @override
  Future<void> restore() async => restoreCalls++;

  @override
  Future<void> bootstrap() async {}
}

AppDeps fakeDeps(
  SharedPreferences prefs, {
  FakeAds? ads,
  FakePurchase? purchase,
  PuzzleFactory? generate,
  bool withSaves = false,
  AdSchedule? schedule,
}) => AppDeps(
  prefs: prefs,
  entitlement: EntitlementStore(prefs),
  purchase: purchase ?? FakePurchase(),
  ads: ads ?? FakeAds(),
  records: RecordStore(prefs),
  settings: SettingsStore(prefs),
  saves: withSaves ? GameSaveStore(prefs) : null,
  generate: generate ?? (_) async => puzzleWithHoles([0, 1, 2]),
  adSchedule: schedule,
);
