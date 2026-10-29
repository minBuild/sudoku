// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/firebase_options.dart';

void main() {
  const skip = firebaseConfigured
      ? false
      : 'Firebase 미설정 (firebase_options.dart 가 TODO) → 주간 기능 숨김';

  test('appId 형식, 두 플랫폼의 projectId·senderId 가 같다', () {
    final a = androidFirebaseOptions, i = iosFirebaseOptions;
    expect(a.appId, matches(RegExp(r'^1:\d+:android:[0-9a-f]+$')));
    expect(i.appId, matches(RegExp(r'^1:\d+:ios:[0-9a-f]+$')));
    expect(a.projectId, i.projectId);
    expect(a.messagingSenderId, i.messagingSenderId);
    expect(a.appId.split(':')[1], a.messagingSenderId);
    expect(a.apiKey, startsWith('AIza'));
    expect(i.apiKey, startsWith('AIza'));
  }, skip: skip);

  test('iOS 번들 ID 가 pbxproj 와 같다', () {
    final pbx = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    expect(
      pbx,
      contains(
        'PRODUCT_BUNDLE_IDENTIFIER = ${iosFirebaseOptions.iosBundleId};',
      ),
    );
  }, skip: skip);

  test('설정 파일(google-services.json 등)을 저장소에 두지 않는다', () {
    expect(File('android/app/google-services.json').existsSync(), isFalse);
    expect(File('ios/Runner/GoogleService-Info.plist').existsSync(), isFalse);
  });
}
