import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/services/hint_budget.dart';

// 힌트 예산은 로컬 날짜가 기준이라 로컬 DateTime 을 주입한다 (날짜만 비교).
void main() {
  late SharedPreferences prefs;
  late DateTime now;

  HintBudget make() => HintBudget(prefs, now: () => now);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    now = DateTime(2026, 10, 29, 22);
  });

  test('3 → consume ×3 → 0, 0 에서 consume 해도 0', () async {
    final b = make();
    expect(b.freeLeft.value, HintBudget.dailyFree);
    for (var i = 2; i >= 0; i--) {
      await b.consume();
      expect(b.freeLeft.value, i);
    }
    await b.consume();
    expect(b.freeLeft.value, 0);
  });

  test('자정이 지나면 3 으로 회복', () async {
    final b = make();
    await b.consume();
    await b.consume();
    await b.consume();
    now = DateTime(2026, 10, 30, 0, 0, 1);
    b.refresh();
    expect(b.freeLeft.value, 3);
    await b.consume();
    expect(b.freeLeft.value, 2);
  });

  test('시계가 역행해도(저장 날짜가 미래) 3', () async {
    final b = make();
    await b.consume();
    now = DateTime(2026, 10, 28, 12);
    b.refresh();
    expect(b.freeLeft.value, 3);
  });

  test('prefs 를 다시 만들어도 유지', () async {
    await make().consume();
    final again = HintBudget(
      await SharedPreferences.getInstance(),
      now: () => now,
    );
    expect(again.freeLeft.value, 2);
  });

  test('깨진 JSON 이면 3', () async {
    await prefs.setString('hint_budget_v1', '{oops');
    expect(make().freeLeft.value, 3);
    await prefs.setString('hint_budget_v1', '{"date": 3, "used": "x"}');
    expect(make().freeLeft.value, 3);
  });
}
