import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_deps.dart';
import 'l10n/l10n.dart';
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
        if (!widget.deps.entitlement.adsRemoved.value) {
          unawaited(widget.deps.ads.warmUp());
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
        // 기기 언어를 따르고, 미지원 언어는 첫 항목(en)으로 폴백한다.
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const HomeScreen(),
      ),
    );
  }
}
