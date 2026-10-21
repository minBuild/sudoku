import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// iOS ATT 요청. 네이티브: AppDelegate 'sudoku/att'. 예외는 삼킨다.
class TrackingAuthorization {
  TrackingAuthorization({MethodChannel? channel})
    : _ch = channel ?? const MethodChannel('sudoku/att');

  final MethodChannel _ch;

  Future<void> requestIfNeeded() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      // 비활성 상태에서 요청하면 창 없이 반환됨
      await _waitResumed(const Duration(seconds: 10));
      await _ch.invokeMethod<void>('request');
    } catch (e) {
      debugPrint('ATT 오류: $e');
    }
  }

  /// resumed 가 될 때까지 최대 [timeout] 기다린다. 지나면 그냥 진행.
  Future<void> _waitResumed(Duration timeout) async {
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      return;
    }
    final resumed = Completer<void>();
    final listener = AppLifecycleListener(
      onResume: () {
        if (!resumed.isCompleted) resumed.complete();
      },
    );
    try {
      await resumed.future.timeout(timeout, onTimeout: () {});
    } finally {
      listener.dispose();
    }
  }
}
