import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_deps.dart';
import 'l10n/l10n.dart';
import 'l10n/locale_resolution.dart';
import 'screens/home_screen.dart';
import 'services/ads/ad_service.dart';
import 'services/game_save_store.dart';
import 'services/purchase/entitlement_store.dart';
import 'services/purchase/purchase_service.dart';
import 'services/record_store.dart';
import 'services/settings_store.dart';
import 'theme/app_theme.dart';

/// 앱 버전 (pubspec 의 version 과 맞춘다).
const appVersion = '2.0.0';

class SudokuApp extends StatefulWidget {
  const SudokuApp({super.key, required this.deps});

  final AppDeps deps;

  @override
  State<SudokuApp> createState() => _SudokuAppState();
}

class _SudokuAppState extends State<SudokuApp> {
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<PurchaseError>? _errors;
  late final AppLifecycleListener _life;

  @override
  void initState() {
    super.initState();
    _errors = widget.deps.purchase.errors.listen(_showPurchaseError);
    // 복귀 시 만료됐거나 비어 있는 캐시를 미리 채운다.
    _life = AppLifecycleListener(
      onResume: () {
        // 광고·통화·백그라운드 뒤 오디오 세션 복구. 광고 제거 사용자도 포함 (D8).
        unawaited(widget.deps.sound.resync());
        if (!widget.deps.entitlement.adsRemoved.value) {
          unawaited(widget.deps.ads.warmUp());
        }
        // 오프라인에서 클리어한 주간 기록을 다시 보낸다.
        if (widget.deps.weekly case final w? when w.store.pending.isNotEmpty) {
          unawaited(w.flushPending());
        }
      },
    );
  }

  // 문구는 Localizations 아래에서 그려지는 SnackBar 안에서 번역한다.
  void _showPurchaseError(PurchaseError e) =>
      _messenger.currentState?.showSnackBar(
        SnackBar(
          content: Builder(
            builder: (c) => Text(switch (e) {
              PurchaseError.purchaseFailed => c.l10n.purchaseFailed,
              PurchaseError.restoreFailed => c.l10n.restoreFailed,
              PurchaseError.restoreNone => c.l10n.restoreNone,
            }),
          ),
        ),
      );

  @override
  void dispose() {
    _errors?.cancel();
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = widget.deps;
    return MultiProvider(
      providers: [
        Provider<AppDeps>.value(value: deps),
        Provider<EntitlementStore>.value(value: deps.entitlement),
        Provider<PurchaseGateway>.value(value: deps.purchase),
        Provider<AdGateway>.value(value: deps.ads),
        Provider<RecordStore>.value(value: deps.records),
        Provider<SettingsStore>.value(value: deps.settings),
        Provider<GameSaveStore?>.value(value: deps.saves),
      ],
      child: MaterialApp(
        onGenerateTitle: (c) => c.l10n.footer,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messenger,
        theme: AppTheme.light(),
        // 기기 언어 목록을 정규화(no→nb, zh-TW/HK/MO→번체)한 뒤 해석하고, 미지원 언어는 첫 항목(en)으로 폴백한다.
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: resolveAppLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const HomeScreen(),
      ),
    );
  }
}
