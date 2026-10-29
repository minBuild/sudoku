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
import 'package:sudoku/services/hint_budget.dart';
import 'package:sudoku/services/purchase/entitlement_store.dart';
import 'package:sudoku/services/purchase/purchase_service.dart';
import 'package:sudoku/services/record_store.dart';
import 'package:sudoku/services/settings_store.dart';
import 'package:sudoku/services/sound/sound_service.dart';
import 'package:sudoku/services/sudoku_generator.dart';
import 'package:sudoku/services/weekly/leaderboard_gateway.dart';
import 'package:sudoku/services/weekly/ranking_policy.dart';
import 'package:sudoku/services/weekly/weekly_service.dart';

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

  int rewardCalls = 0;
  int preloadRewardedCalls = 0;

  /// 보상형 광고 결과. 기본은 unavailable.
  RewardOutcome onReward = RewardOutcome.unavailable;

  /// 광고가 떠 있는 동안 호출된다. 상태 단언·라이프사이클 변경용.
  FutureOr<void> Function()? duringReward;

  @override
  Future<RewardOutcome> showRewardedAd() async {
    rewardCalls++;
    await duringReward?.call();
    return onReward;
  }

  @override
  void preloadRewarded() => preloadRewardedCalls++;

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

class FakeSound implements SoundGateway {
  final played = <(SoundCue, double)>[];
  int warmUpCalls = 0;
  int resyncCalls = 0;

  @override
  Future<void> warmUp() async => warmUpCalls++;

  @override
  Future<void> resync() async => resyncCalls++;

  @override
  void play(SoundCue cue, {double volume = 1}) => played.add((cue, volume));
}

/// 메모리 리더보드. `write` 는 [RankingPolicy] 로 서버 거부를 흉내 낸다.
class FakeLeaderboard implements LeaderboardGateway {
  FakeLeaderboard({this.myUid = 'me'});

  final String myUid;
  bool offline = false;

  /// board → uid → entry
  final boards = <String, Map<String, LeaderEntry>>{};

  int ensureCalls = 0;
  int mineCalls = 0;
  int topCalls = 0;
  int writeCalls = 0;
  int updateNickCalls = 0;
  int get calls =>
      ensureCalls + mineCalls + topCalls + writeCalls + updateNickCalls;

  void seed(String board, String uid, int ms, [String nick = '']) =>
      (boards[board] ??= {})[uid] = LeaderEntry(uid: uid, ms: ms, nick: nick);

  @override
  Future<LbResult<String>> ensureUser() async {
    ensureCalls++;
    return offline ? const LbFail() : LbOk(myUid);
  }

  @override
  Future<LbResult<LeaderEntry?>> mine(String board, String uid) async {
    mineCalls++;
    if (offline) return const LbFail();
    return LbOk(boards[board]?[uid]);
  }

  @override
  Future<LbResult<LeaderEntry?>> top(String board) async {
    topCalls++;
    if (offline) return const LbFail();
    final all = boards[board]?.values.toList() ?? [];
    if (all.isEmpty) return const LbOk(null);
    all.sort((a, b) => a.ms.compareTo(b.ms));
    return LbOk(all.first);
  }

  @override
  Future<LbResult<void>> write(
    String board,
    String uid, {
    required int ms,
    required String nick,
  }) async {
    writeCalls++;
    if (offline) return const LbFail();
    final old = boards[board]?[uid];
    if (!RankingPolicy.shouldWrite(existingMs: old?.ms, newMs: ms)) {
      return const LbFail();
    }
    seed(board, uid, ms, nick);
    return const LbOk(null);
  }

  @override
  Future<LbResult<void>> updateNick(
    String board,
    String uid,
    String nick,
  ) async {
    updateNickCalls++;
    final old = boards[board]?[uid];
    if (offline || old == null) return const LbFail();
    seed(board, uid, old.ms, nick);
    return const LbOk(null);
  }
}

AppDeps fakeDeps(
  SharedPreferences prefs, {
  FakeAds? ads,
  FakePurchase? purchase,
  PuzzleFactory? generate,
  bool withSaves = false,
  AdSchedule? schedule,
  Future<bool> Function(Uri)? openUrl,
  Uri? privacyPolicyUri,
  FakeSound? sound,
  HintBudget? hintBudget,
  WeeklyService? weekly,
}) => AppDeps(
  prefs: prefs,
  entitlement: EntitlementStore(prefs),
  purchase: purchase ?? FakePurchase(),
  ads: ads ?? FakeAds(),
  records: RecordStore(prefs),
  settings: SettingsStore(prefs),
  saves: withSaves ? GameSaveStore(prefs) : null,
  generate: generate ?? (PuzzleRequest r) async => puzzleWithHoles([0, 1, 2]),
  adSchedule: schedule,
  openUrl: openUrl,
  privacyPolicyUri: privacyPolicyUri,
  sound: sound,
  hintBudget: hintBudget,
  weekly: weekly,
);
