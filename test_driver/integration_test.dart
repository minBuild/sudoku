import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// `flutter drive` 호스트 측. 테스트가 찍은 스크린샷을 PNG 로 저장한다.
/// 저장 위치는 SCREENSHOT_DIR 환경 변수 (기본: build/screenshots).
Future<void> main() async {
  final dir = Directory(
    Platform.environment['SCREENSHOT_DIR'] ?? 'build/screenshots',
  )..createSync(recursive: true);
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('${dir.path}/$name.png');
      await file.writeAsBytes(bytes);
      // ignore: avoid_print
      print('screenshot saved: ${file.path} (${bytes.length} bytes)');
      return true;
    },
  );
}
