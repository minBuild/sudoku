import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';

import '../fakes.dart';

final _uri = Uri.parse('https://example.com/privacy');

Future<void> _pumpSettings(
  WidgetTester tester, {
  Uri? privacyPolicyUri,
  Future<bool> Function(Uri)? openUrl,
  FakeAds? ads,
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    SudokuApp(
      deps: fakeDeps(
        prefs,
        ads: ads,
        openUrl: openUrl,
        privacyPolicyUri: privacyPolicyUri,
      ),
    ),
  );
  await tester.pump();
  await tester.tap(find.text(l10nEn.settings));
  await tester.pumpAndSettle();
  expect(find.text(l10nEn.restorePurchases), findsOneWidget);
}

void main() {
  testWidgets('URL 이 없으면 방침 행이 없다', (tester) async {
    await _pumpSettings(tester);
    expect(find.text(l10nEn.privacyPolicy), findsNothing);
  });

  testWidgets('연타해도 openUrl 은 1회, 인자는 주입한 Uri', (tester) async {
    final calls = <Uri>[];
    final pending = Completer<bool>();
    await _pumpSettings(
      tester,
      privacyPolicyUri: _uri,
      openUrl: (u) {
        calls.add(u);
        return pending.future;
      },
    );
    expect(find.text(l10nEn.privacyPolicy), findsOneWidget);

    await tester.tap(find.text(l10nEn.privacyPolicy));
    await tester.tap(find.text(l10nEn.privacyPolicy));
    await tester.pump();
    expect(calls, [_uri]);

    pending.complete(true);
    await tester.pumpAndSettle();
    expect(find.text(l10nEn.openLinkFailed), findsNothing);
  });

  testWidgets('openUrl 이 false 면 스낵바', (tester) async {
    await _pumpSettings(
      tester,
      privacyPolicyUri: _uri,
      openUrl: (_) async => false,
    );
    await tester.tap(find.text(l10nEn.privacyPolicy));
    await tester.pump();
    await tester.pump();
    expect(find.text(l10nEn.openLinkFailed), findsOneWidget);
  });

  testWidgets('UMP 개인정보 옵션이 없어도 방침 행은 보인다', (tester) async {
    final ads = FakeAds()..privacyOptionsRequired = false;
    await _pumpSettings(tester, privacyPolicyUri: _uri, ads: ads);
    expect(find.text(l10nEn.privacyOptions), findsNothing);
    expect(find.text(l10nEn.privacyPolicy), findsOneWidget);
  });
}
