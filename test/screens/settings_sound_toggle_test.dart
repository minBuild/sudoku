import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/app.dart';
import 'package:sudoku/l10n/difficulty_label.dart';
import 'package:sudoku/models/difficulty.dart';

import '../fakes.dart';

const _key = 'settings_sound_v1';

final _soundSwitch = find.widgetWithText(SwitchListTile, l10nEn.soundEffects);

Future<void> _pumpApp(WidgetTester tester, SharedPreferences prefs) async {
  await tester.pumpWidget(SudokuApp(deps: fakeDeps(prefs)));
  await tester.pump();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.text(l10nEn.settings));
  await tester.pumpAndSettle();
  expect(_soundSwitch, findsOneWidget);
}

bool _switchValue(WidgetTester tester) =>
    tester.widget<SwitchListTile>(_soundSwitch).value;

Future<void> _enterGame(WidgetTester tester) async {
  await tester.tap(find.text(l10nEn.newGame));
  await tester.pumpAndSettle();
  await tester.tap(find.text(Difficulty.easy.label(l10nEn)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
  expect(find.text(l10nEn.undo), findsOneWidget);
}

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.byTooltip(l10nEn.more));
  await tester.pumpAndSettle();
}

// 메뉴 값 타입(_MenuAction)이 비공개라 byType 대신 predicate 로 찾는다.
final _menuItem = find.ancestor(
  of: find.text(l10nEn.soundEffects),
  matching: find.byWidgetPredicate((w) => w is CheckedPopupMenuItem),
);

bool _menuChecked(WidgetTester tester) =>
    tester.widget<CheckedPopupMenuItem<dynamic>>(_menuItem).checked;

void main() {
  testWidgets('설정 스위치를 끄면 저장되고 다시 열어도 유지된다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await _pumpApp(tester, prefs);
    await _openSettings(tester);
    expect(_switchValue(tester), isTrue); // 기본값 켜짐

    await tester.tap(_soundSwitch);
    await tester.pumpAndSettle();
    expect(prefs.getBool(_key), isFalse);
    expect(_switchValue(tester), isFalse);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await _openSettings(tester);
    expect(_switchValue(tester), isFalse);
  });

  for (final on in [true, false]) {
    testWidgets('게임 ⋮ 메뉴의 효과음 체크 = 설정 값 ($on)', (tester) async {
      SharedPreferences.setMockInitialValues({_key: on});
      final prefs = await SharedPreferences.getInstance();
      await _pumpApp(tester, prefs);
      await _enterGame(tester);
      await _openMenu(tester);
      expect(_menuChecked(tester), on);
      await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리
    });
  }

  testWidgets('메뉴에서 토글하면 설정 화면에도 반영된다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await _pumpApp(tester, prefs);
    await _enterGame(tester);
    await _openMenu(tester);
    await tester.tap(_menuItem);
    await tester.pumpAndSettle();
    expect(prefs.getBool(_key), isFalse);

    await _openMenu(tester);
    expect(_menuChecked(tester), isFalse);
    await tester.pumpWidget(const SizedBox()); // 게임 타이머 정리

    await _pumpApp(tester, prefs);
    await _openSettings(tester);
    expect(_switchValue(tester), isFalse);
  });
}
