import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../l10n/strings.dart';
import 'entitlement_store.dart';

sealed class PurchaseUiState {
  const PurchaseUiState();
}

final class PurchaseLoading extends PurchaseUiState {
  const PurchaseLoading();
}

final class PurchaseUnavailable extends PurchaseUiState {
  const PurchaseUnavailable(this.reason);
  final String reason;
}

final class PurchaseReady extends PurchaseUiState {
  const PurchaseReady(this.price, this.currencyCode);

  /// 스토어가 돌려준 표시 가격 (`ProductDetails.price`).
  final String price;
  final String currencyCode;
}

final class PurchasePending extends PurchaseUiState {
  const PurchasePending();
}

final class PurchaseOwned extends PurchaseUiState {
  const PurchaseOwned();
}

abstract interface class PurchaseGateway {
  ValueListenable<PurchaseUiState> get state;

  /// 스낵바용 메시지.
  Stream<String> get errors;

  /// Ready 에서만 동작한다. 중복 호출은 무시.
  Future<void> buy();

  Future<void> restore();

  /// 스토어 연결과 상품 조회. throw 하지 않는다.
  Future<void> bootstrap();
}

class PurchaseService implements PurchaseGateway {
  static const productId = 'remove_ads';
  static const _stepTimeout = Duration(seconds: 10);

  PurchaseService(this._entitlement, {InAppPurchase? iap})
    : _iapOverride = iap,
      _state = ValueNotifier(
        _entitlement.adsRemoved.value
            ? const PurchaseOwned()
            : const PurchaseLoading(),
      );

  final EntitlementStore _entitlement;
  final InAppPurchase? _iapOverride;
  final ValueNotifier<PurchaseUiState> _state;
  final _errors = StreamController<String>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _sub;
  ProductDetails? _product;
  bool _busy = false;

  InAppPurchase get _iap => _iapOverride ?? InAppPurchase.instance;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  ValueListenable<PurchaseUiState> get state => _state;

  @override
  Stream<String> get errors => _errors.stream;

  /// runApp 전에 동기로 구독한다 (D13).
  void listen() {
    if (_sub != null) return;
    try {
      _sub = _iap.purchaseStream.listen(
        _onPurchases,
        onError: (Object e) => debugPrint('IAP stream 오류: $e'),
      );
    } catch (e) {
      debugPrint('IAP listen 오류: $e');
    }
  }

  /// isAvailable → queryProductDetails, 그다음 (Android) restorePurchases.
  @override
  Future<void> bootstrap() async {
    await _queryProduct();
    // Android 만 자동 복원. iOS 는 Apple ID 로그인 창이 뜰 수 있다 (D14).
    if (_isAndroid && !_entitlement.adsRemoved.value) {
      try {
        await _iap.restorePurchases().timeout(_stepTimeout);
      } catch (e) {
        debugPrint('IAP restore 오류: $e'); // 사용자 동작이 아니므로 스낵바 없음
      }
    }
  }

  /// 스토어 연결과 상품 조회. throw 하지 않는다.
  Future<void> _queryProduct() async {
    try {
      final available = await _iap.isAvailable().timeout(_stepTimeout);
      if (!available) {
        _setIfNotOwned(const PurchaseUnavailable('store unavailable'));
        return;
      }

      final resp = await _iap
          .queryProductDetails({productId})
          .timeout(_stepTimeout);
      final p = resp.productDetails.where((e) => e.id == productId).firstOrNull;
      if (resp.notFoundIDs.contains(productId) || p == null) {
        _setIfNotOwned(const PurchaseUnavailable('product not found'));
        return;
      }
      debugPrint(
        'IAP price=${p.price} raw=${p.rawPrice} cur=${p.currencyCode}',
      );
      _product = p;
      _setIfNotOwned(_ready());
    } catch (e) {
      debugPrint('IAP bootstrap 오류: $e');
      if (_product == null) {
        _setIfNotOwned(const PurchaseUnavailable('bootstrap failed'));
      }
    }
  }

  @override
  Future<void> buy() async {
    final p = _product;
    if (_busy || p == null || _state.value is! PurchaseReady) return;
    _busy = true;
    try {
      final started = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: p),
      );
      if (!started) _busy = false;
    } catch (e) {
      debugPrint('IAP buy 오류: $e');
      _busy = false;
      _errors.add(S.purchaseFailed);
    }
  }

  @override
  Future<void> restore() async {
    try {
      await _iap.restorePurchases().timeout(_stepTimeout);
    } catch (e) {
      debugPrint('IAP restore 오류: $e');
      _errors.add(S.restoreFailed);
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> list) async {
    for (final p in list) {
      try {
        if (p.productID == productId) {
          switch (p.status) {
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              await _entitlement.grant();
              _state.value = const PurchaseOwned();
              _busy = false;
            case PurchaseStatus.pending:
              _setIfNotOwned(const PurchasePending());
            case PurchaseStatus.error:
              _busy = false;
              _revert();
              final msg = p.error?.message ?? '';
              if (_isAndroid && msg.contains('itemAlreadyOwned')) {
                unawaited(restore());
              } else {
                _errors.add(S.purchaseFailed);
              }
            case PurchaseStatus.canceled:
              _busy = false;
              _revert();
          }
        }
        // 상태와 관계없이 complete 해야 환불·재시도 루프가 생기지 않는다.
        if (p.pendingCompletePurchase) {
          await _iap.completePurchase(p);
        }
      } catch (e) {
        debugPrint('IAP 처리 오류: $e');
      }
    }
  }

  PurchaseUiState _ready() {
    final p = _product;
    if (p == null) return const PurchaseUnavailable('no product');
    return PurchaseReady(p.price, p.currencyCode);
  }

  void _revert() => _setIfNotOwned(_ready());

  void _setIfNotOwned(PurchaseUiState s) {
    if (_state.value is PurchaseOwned) return;
    _state.value = s;
  }

  void dispose() {
    _sub?.cancel();
    _errors.close();
  }
}
