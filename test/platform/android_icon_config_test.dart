import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// flutter_launcher_icons 생성 결과를 읽어 대조한다.
/// 정규식에 줄끝 앵커를 쓰지 않는다 (CRLF 안전).
String _read(String path) => File(path).readAsStringSync();

void main() {
  const res = 'android/app/src/main/res';

  test('AndroidManifest 아이콘은 @mipmap/launcher_icon', () {
    expect(
      _read('android/app/src/main/AndroidManifest.xml'),
      contains('android:icon="@mipmap/launcher_icon"'),
    );
  });

  test('adaptive 아이콘: monochrome 이 있고 inset 은 0%', () {
    final xml = _read('$res/mipmap-anydpi-v26/launcher_icon.xml');
    expect(xml, contains('<monochrome>'));
    expect(xml, contains('@drawable/ic_launcher_foreground'));
    expect(xml, contains('@drawable/ic_launcher_monochrome'));
    final insets = RegExp(
      r'android:inset="([^"]+)"',
    ).allMatches(xml).map((m) => m.group(1)).toSet();
    expect(insets, {'0%'});
  });

  test('adaptive 배경색은 #3B5BDB', () {
    expect(_read('$res/values/colors.xml').toUpperCase(), contains('#3B5BDB'));
  });

  test('iOS AppIcon 에 dark · tinted 항목이 있다', () {
    final json =
        jsonDecode(
              _read(
                'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
              ),
            )
            as Map<String, dynamic>;
    final values = <String>{
      for (final img in json['images'] as List)
        for (final a in ((img as Map)['appearances'] as List?) ?? const [])
          (a as Map)['value'] as String,
    };
    expect(values, containsAll(['dark', 'tinted']));
  });
}
