import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_deps.dart';
import 'l10n/strings.dart';
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
  StreamSubscription<String>? _errors;

  @override
  void initState() {
    super.initState();
    _errors = widget.deps.purchase.errors.listen(_showPurchaseError);
  }

  void _showPurchaseError(String msg) {
    _messenger.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _errors?.cancel();
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
        title: S.footer,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messenger,
        theme: AppTheme.light(),
        locale: const Locale('ko'),
        supportedLocales: const [Locale('ko')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const HomeScreen(),
      ),
    );
  }
}
