import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Windows 에서 iOS 를 빌드할 수 없으므로 설정 파일을 읽어 대조한다.
/// 정규식에 줄끝 앵커를 쓰지 않는다 (CRLF 안전).
String _read(String path) => File(path).readAsStringSync();

Set<String> _values(String text, String key) => RegExp(
  '$key = ([^;]+);',
).allMatches(text).map((m) => m.group(1)!.trim()).toSet();

void main() {
  const pbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj';
  const plistPath = 'ios/Runner/Info.plist';

  test('Podfile: platform :ios 15.0 이 주석 해제돼 있다', () {
    final podfile = _read('ios/Podfile');
    expect(
      RegExp(r"^platform :ios, '15\.0'", multiLine: true).hasMatch(podfile),
      isTrue,
    );
  });

  test('배포 타깃은 모두 15.0 이고 MinimumOSVersion 과 같다', () {
    final targets = _values(_read(pbxprojPath), 'IPHONEOS_DEPLOYMENT_TARGET');
    expect(targets, {'15.0'});

    final m = RegExp(
      r'<key>MinimumOSVersion</key>\s*<string>([^<]+)</string>',
    ).firstMatch(_read('ios/Flutter/AppFrameworkInfo.plist'));
    expect(m?.group(1), '15.0');
  });

  test('번들 ID 는 io.minbuild.sudoku 와 테스트 타깃뿐이다', () {
    expect(_values(_read(pbxprojPath), 'PRODUCT_BUNDLE_IDENTIFIER'), {
      'io.minbuild.sudoku',
      'io.minbuild.sudoku.RunnerTests',
    });
  });

  test('iPhone 전용 (TARGETED_DEVICE_FAMILY = 1)', () {
    // Xcode 는 저장할 때 "1" 을 1 로 바꿔 쓴다. 둘 다 iPhone 전용이다.
    final v = _values(
      _read(pbxprojPath),
      'TARGETED_DEVICE_FAMILY',
    ).map((e) => e.replaceAll('"', '')).toSet();
    expect(v, {'1'});
  });

  test('Info.plist 필수 항목', () {
    final plist = _read(plistPath);
    void hasPair(String key, String value) => expect(
      RegExp(
        '<key>${RegExp.escape(key)}</key>\\s*${RegExp.escape(value)}',
      ).hasMatch(plist),
      isTrue,
      reason: key,
    );

    hasPair(
      'GADApplicationIdentifier',
      r'<string>$(GAD_APPLICATION_ID)</string>',
    );
    hasPair('ITSAppUsesNonExemptEncryption', '<false/>');
    hasPair(
      'CFBundleShortVersionString',
      r'<string>$(FLUTTER_BUILD_NAME)</string>',
    );
    hasPair('CFBundleVersion', r'<string>$(FLUTTER_BUILD_NUMBER)</string>');
    expect(plist, contains('<key>SKAdNetworkItems</key>'));
    expect(plist, contains('cstr6suwn9.skadnetwork'));
    expect(
      RegExp(
        r'<key>NSUserTrackingUsageDescription</key>\s*<string>[^<]+</string>',
      ).hasMatch(plist),
      isTrue,
    );
    expect(plist, contains('<key>UIApplicationSceneManifest</key>'));
    expect(plist, contains('FlutterSceneDelegate'));
    expect(plist, contains('<key>UILaunchStoryboardName</key>'));
  });

  test('런치 스토리보드가 있다', () {
    expect(
      File('ios/Runner/Base.lproj/LaunchScreen.storyboard').existsSync(),
      isTrue,
    );
  });

  test('1024 앱 아이콘은 알파 채널이 없는 PNG 다', () {
    final bytes = File(
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
    ).readAsBytesSync();
    expect(bytes.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
    expect(bytes[24], 8, reason: 'bit depth');
    expect(bytes[25], anyOf(0, 2), reason: 'color type (알파 없음)');
  });

  test('xcconfig 에 Pods include 가 있다', () {
    expect(
      _read('ios/Flutter/Debug.xcconfig'),
      contains(
        '#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"',
      ),
    );
    expect(
      _read('ios/Flutter/Release.xcconfig'),
      contains(
        '#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"',
      ),
    );
  });

  group('지역화', () {
    /// ARB 언어 코드 → Apple 지역화 코드.
    String appleCode(String arb) => switch (arb) {
      'zh' => 'zh-Hans',
      'zh_Hant' => 'zh-Hant',
      _ => arb,
    };

    final langs = Directory('lib/l10n')
        .listSync()
        .map((f) => RegExp(r'app_(\w+)\.arb$').firstMatch(f.path)?.group(1))
        .whereType<String>()
        .map(appleCode)
        .toSet();
    const koAtt = '맞춤형 광고를 제공하기 위해 기기 식별자를 사용합니다. 허용하지 않아도 앱은 정상적으로 이용할 수 있어요.';

    String? plistString(String key) => RegExp(
      '<key>${RegExp.escape(key)}</key>\\s*<string>([^<]*)</string>',
    ).firstMatch(_read(plistPath))?.group(1);

    Map<String, dynamic> attLocalizations() {
      final doc =
          jsonDecode(_read('ios/Runner/InfoPlist.xcstrings'))
              as Map<String, dynamic>;
      expect(doc['sourceLanguage'], 'en');
      final strings = doc['strings'] as Map<String, dynamic>;
      final att = strings['NSUserTrackingUsageDescription'] as Map;
      return att['localizations'] as Map<String, dynamic>;
    }

    String attValue(Map<String, dynamic> locs, String lang) =>
        (locs[lang] as Map)['stringUnit']['value'] as String;

    test('ARB 언어에 en·ko·간체·번체가 있다', () {
      expect(langs, containsAll(['en', 'ko', 'zh-Hans', 'zh-Hant']));
    });

    test('CFBundleLocalizations 가 ARB 언어와 같다', () {
      final m = RegExp(
        r'<key>CFBundleLocalizations</key>\s*<array>([\s\S]*?)</array>',
      ).firstMatch(_read(plistPath));
      final plistLangs = RegExp(
        r'<string>([^<]+)</string>',
      ).allMatches(m!.group(1)!).map((e) => e.group(1)!).toList();
      expect(plistLangs.toSet(), langs);
      expect(plistLangs.length, langs.length, reason: '중복 없음');
    });

    test('CFBundleDevelopmentRegion 은 en', () {
      expect(plistString('CFBundleDevelopmentRegion'), 'en');
    });

    test('InfoPlist.xcstrings: ATT 문구가 ARB 언어 모두 번역됨', () {
      final locs = attLocalizations();
      expect(locs.keys.toSet(), langs);
      for (final l in langs) {
        final unit = (locs[l] as Map)['stringUnit'] as Map;
        expect(unit['state'], 'translated', reason: l);
        expect((unit['value'] as String).trim(), isNotEmpty, reason: l);
      }
    });

    test('xcstrings ko 는 기존 문구, en 은 Info.plist 원문과 같다', () {
      final locs = attLocalizations();
      expect(attValue(locs, 'ko'), koAtt);
      expect(
        attValue(locs, 'en'),
        plistString('NSUserTrackingUsageDescription'),
      );
    });

    test('pbxproj: Runner 리소스에만 xcstrings, knownRegions 는 ARB 언어 + Base', () {
      final pbx = _read(pbxprojPath);
      String block(String header) {
        final start = pbx.indexOf(header);
        expect(start, isNot(-1), reason: header);
        return pbx.substring(start, pbx.indexOf('};', start));
      }

      expect(
        block('97C146EC1CF9000F007C117D /* Resources */ = {'),
        contains('InfoPlist.xcstrings in Resources'),
      );
      expect(
        block('331C807F294A63A400263BE5 /* Resources */ = {'),
        isNot(contains('InfoPlist.xcstrings')),
      );
      final regions = RegExp(r'knownRegions = \(([^)]*)\)')
          .firstMatch(pbx)!
          .group(1)!
          .split(',')
          .map((e) => e.replaceAll('"', '').trim())
          .where((e) => e.isNotEmpty)
          .toSet();
      expect(regions, contains('Base'));
      expect(regions.difference({'Base'}), langs);
    });
  });
}
