import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/ads/ad_ids.dart';

const sample = '3940256099942544';
const sampleAppId = 'ca-app-pub-3940256099942544~1458002511';

/// [keyPattern] 뒤의 첫 AdMob ID. 줄끝 앵커가 없어 CRLF 에도 안전하다.
String? grab(String path, String keyPattern) => RegExp(
  '$keyPattern\\s*=\\s*"?(ca-app-pub-[0-9~/]+)',
).firstMatch(File(path).readAsStringSync())?.group(1);

/// 게시자 16자리.
String? pub(RegExp re, String id) => re.firstMatch(id)?.group(1);

final _pubRe = RegExp(r'^ca-app-pub-(\d{16})[~/]');

void main() {
  const release = 'ios/Flutter/Release.xcconfig';
  const debug = 'ios/Flutter/Debug.xcconfig';

  test('디버그·프로필(release:false)은 항상 샘플', () {
    const valid = 'ca-app-pub-1234567890123456/1234567890';
    for (final env in ['', valid]) {
      expect(
        AdIds.resolve(release: false, ios: true, env: env),
        AdIds.iosSample,
      );
      expect(
        AdIds.resolve(release: false, ios: false, env: env),
        AdIds.androidSample,
      );
    }
  });

  test('iOS 릴리스 기본값은 실제 단위 ID 이고 Release.xcconfig 와 게시자가 같다', () {
    final id = AdIds.resolve(release: true, ios: true);
    expect(id, AdIds.iosProd);
    expect(AdIds.unitRe.hasMatch(id), isTrue);
    final publisher = pub(_pubRe, id);
    expect(publisher, isNot(sample));

    final appId = grab(release, r'GAD_APPLICATION_ID(?!\[)');
    expect(appId, matches(RegExp(r'^ca-app-pub-\d{16}~\d{10}$')));
    expect(pub(_pubRe, appId!), publisher);
  });

  test('Debug 와 Profile 의 App ID 는 샘플', () {
    expect(grab(debug, 'GAD_APPLICATION_ID'), sampleAppId);
    expect(grab(release, r'GAD_APPLICATION_ID\[config=Profile\]'), sampleAppId);
  });

  test('README 에 iOS 단위 ID 와 App ID 가 기록돼 있다', () {
    final readme = File('README.md').readAsStringSync();
    expect(readme, contains(AdIds.iosProd));
    expect(readme, contains(grab(release, r'GAD_APPLICATION_ID(?!\[)')!));
  });

  test('dart-define 자리표시자는 무시하고, 유효한 값은 덮어쓴다', () {
    expect(
      AdIds.resolve(
        release: true,
        ios: true,
        env: 'ca-app-pub-xxxxxxxx/xxxxxxxx',
      ),
      AdIds.iosProd,
    );
    final override = 'ca-app-pub-${pub(_pubRe, AdIds.iosProd)}/1234567890';
    expect(AdIds.resolve(release: true, ios: true, env: override), override);
  });

  test('Android 릴리스는 비어 있거나 iOS 와 같은 게시자의 다른 ID', () {
    final android = AdIds.resolve(release: true, ios: false);
    if (android.isEmpty) return;
    expect(AdIds.unitRe.hasMatch(android), isTrue);
    expect(pub(_pubRe, android), pub(_pubRe, AdIds.iosProd));
    expect(android, isNot(AdIds.iosProd));
  });

  test('ads.example.json 은 ADMOB_TEST_DEVICES 만 둔다', () {
    final json =
        jsonDecode(File('config/ads.example.json').readAsStringSync())
            as Map<String, dynamic>;
    expect(json.keys.toSet(), {'ADMOB_TEST_DEVICES'});
  });

  test('플랫폼 설정이 App ID 변수를 참조한다', () {
    expect(
      File('ios/Runner/Info.plist').readAsStringSync(),
      contains(r'$(GAD_APPLICATION_ID)'),
    );
    expect(
      File('android/app/src/main/AndroidManifest.xml').readAsStringSync(),
      contains(r'${admobAppId}'),
    );
  });
}
