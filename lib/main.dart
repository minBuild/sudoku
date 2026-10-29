import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_deps.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (d) {
    FlutterError.presentError(d);
    debugPrint('${d.exception}\n${d.stack}');
  };
  PlatformDispatcher.instance.onError = (e, s) {
    debugPrint('$e\n$s');
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  // entitlement 동기 로드 + purchase.listen() 동기 구독 (D13)
  final deps = AppDeps.production(prefs);
  runApp(SudokuApp(deps: deps));

  unawaited(deps.purchase.bootstrap()); // 단계별 timeout 10s, 내부 try/catch
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!deps.entitlement.adsRemoved.value) unawaited(deps.ads.warmUp());
    // 설정과 무관하게 항상 준비한다. 켜고 끄기는 재생 직전에 확인한다 (D7).
    unawaited(deps.sound.warmUp());
  });
}
