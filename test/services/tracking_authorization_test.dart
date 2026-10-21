import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/ads/tracking_authorization.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('sudoku/att');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late int calls;

  setUp(() {
    calls = 0;
    TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'request') calls++;
      return null;
    });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('iOS: request 를 1회 호출한다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await TrackingAuthorization().requestIfNeeded();
    expect(calls, 1);
  });

  test('Android: 호출하지 않는다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await TrackingAuthorization().requestIfNeeded();
    expect(calls, 0);
  });

  test('네이티브 핸들러가 없어도 throw 하지 않는다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    messenger.setMockMethodCallHandler(channel, null);
    await expectLater(TrackingAuthorization().requestIfNeeded(), completes);
  });
}
