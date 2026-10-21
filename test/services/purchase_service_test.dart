import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku/services/purchase/entitlement_store.dart';
import 'package:sudoku/services/purchase/purchase_service.dart';

class _FakeIap implements InAppPurchase {
  _FakeIap(this.onQuery);

  final Future<ProductDetailsResponse> Function() onQuery;
  int restoreCalls = 0;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) =>
      onQuery();

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    restoreCalls++;
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Future<ProductDetailsResponse> _throws() async => throw Exception('offline');

Future<ProductDetailsResponse> _empty() async =>
    ProductDetailsResponse(productDetails: const [], notFoundIDs: const []);

Future<PurchaseService> _service(
  _FakeIap fake, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  return PurchaseService(EntitlementStore(sp), iap: fake);
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('Android: 상품 조회가 throw 해도 자동 복원을 시도한다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final fake = _FakeIap(_throws);
    final service = await _service(fake);

    await service.bootstrap();

    expect(fake.restoreCalls, 1);
    expect(service.state.value, isA<PurchaseUnavailable>());
  });

  test('Android: 상품 조회가 끝나지 않아도 타임아웃 뒤 자동 복원을 시도한다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final fake = _FakeIap(() => Completer<ProductDetailsResponse>().future);
    final service = await _service(fake);

    fakeAsync((async) {
      unawaited(service.bootstrap());
      async.elapse(const Duration(seconds: 11));
      async.flushMicrotasks();
      expect(fake.restoreCalls, 1);
      expect(service.state.value, isA<PurchaseUnavailable>());
    });
  });

  test('iOS: 자동 복원을 하지 않는다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final fake = _FakeIap(_empty);
    final service = await _service(fake);

    await service.bootstrap();

    expect(fake.restoreCalls, 0);
  });

  test('이미 광고 제거 상태면 복원하지 않고 Owned 를 유지한다', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final fake = _FakeIap(_empty);
    final service = await _service(fake, prefs: {'ent_ads_removed_v1': true});

    await service.bootstrap();

    expect(fake.restoreCalls, 0);
    expect(service.state.value, isA<PurchaseOwned>());
  });
}
