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

  group('Android App ID 짝 불변식', () {
    const gradle = 'android/app/build.gradle.kts';
    final appId = RegExp(
      r'prodAdmobAppId = "([^"]*)"',
    ).firstMatch(File(gradle).readAsStringSync())?.group(1);

    test('build.gradle.kts 에 prodAdmobAppId 가 있고 단위 ID 와 함께 비거나 함께 있다', () {
      expect(appId, isNotNull);
      expect(AdIds.androidProd.isEmpty, appId!.isEmpty);
    });

    test('둘 다 있으면 실제 게시자 App ID 이고 단위와 게시자가 같다', () {
      if (appId!.isEmpty) return;
      expect(appId, matches(RegExp(r'^ca-app-pub-7432278320907197~\d{10}$')));
      expect(appId, isNot(contains(sample)));
      expect(pub(_pubRe, appId), pub(_pubRe, AdIds.androidProd));
    });

    test('README 에 Android 단위 ID 와 App ID 가 기록돼 있다', () {
      if (appId!.isEmpty) return;
      final readme = File('README.md').readAsStringSync();
      expect(readme, contains(AdIds.androidProd));
      expect(readme, contains(appId));
    });
  });

  group('보상형', () {
    test('디버그는 샘플, 형식이 맞다', () {
      expect(
        AdIds.resolveRewarded(release: false, ios: true),
        AdIds.iosRewardedSample,
      );
      expect(
        AdIds.resolveRewarded(release: false, ios: false),
        AdIds.androidRewardedSample,
      );
      for (final id in [AdIds.iosRewardedSample, AdIds.androidRewardedSample]) {
        expect(AdIds.unitRe.hasMatch(id), isTrue, reason: id);
      }
    });

    test('릴리스는 prod 기본값, 유효한 dart-define 은 덮어쓴다', () {
      expect(
        AdIds.resolveRewarded(release: true, ios: true),
        AdIds.iosRewardedProd,
      );
      expect(
        AdIds.resolveRewarded(release: true, ios: false),
        AdIds.androidRewardedProd,
      );
      const override = 'ca-app-pub-1234567890123456/1234567890';
      expect(
        AdIds.resolveRewarded(release: true, ios: false, env: override),
        override,
      );
      expect(
        AdIds.resolveRewarded(release: true, ios: true, env: 'bad'),
        AdIds.iosRewardedProd,
      );
    });

    for (final (name, id, sibling) in [
      ('iOS', AdIds.iosRewardedProd, AdIds.iosProd),
      ('Android', AdIds.androidRewardedProd, AdIds.androidProd),
    ]) {
      test(
        '$name prod 단위는 형식이 맞고 전면광고와 같은 게시자이며 README 에 있다',
        () {
          expect(AdIds.unitRe.hasMatch(id), isTrue);
          expect(pub(_pubRe, id), pub(_pubRe, sibling));
          expect(id, isNot(sibling));
          expect(File('README.md').readAsStringSync(), contains(id));
        },
        skip: id.isEmpty
            ? '$name 보상형 단위가 아직 없음 (콘솔에서 만든 뒤 AdIds 에 넣는다)'
            : false,
      );
    }
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
