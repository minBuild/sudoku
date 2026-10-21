import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku/services/ads/ad_service.dart';
import 'package:sudoku/services/ads/consent_service.dart';

enum _Mode { silent, success, failure }

class _Info extends Fake implements ConsentInformation {
  _Info(this.mode);

  final _Mode mode;

  @override
  void requestConsentInfoUpdate(
    ConsentRequestParameters params,
    OnConsentInfoUpdateSuccessListener successListener,
    OnConsentInfoUpdateFailureListener failureListener,
  ) {
    switch (mode) {
      case _Mode.silent:
        return;
      case _Mode.success:
        successListener();
      case _Mode.failure:
        failureListener(FormError(errorCode: 1, message: 'test'));
    }
  }

  @override
  Future<PrivacyOptionsRequirementStatus>
  getPrivacyOptionsRequirementStatus() async =>
      PrivacyOptionsRequirementStatus.required;

  @override
  Future<bool> canRequestAds() async => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late int forms;
  Future<void> loadAndShow(OnConsentFormDismissedListener listener) async {
    forms++;
    listener(null);
  }

  setUp(() => forms = 0);

  test('갱신 무응답이면 10초 뒤 폼 없이 완료', () {
    fakeAsync((fa) {
      final s = ConsentService(
        info: _Info(_Mode.silent),
        loadAndShow: loadAndShow,
      );
      var done = false;
      s.gather().then((_) => done = true);

      fa.elapse(const Duration(seconds: 9));
      expect(done, isFalse);

      fa.elapse(const Duration(seconds: 2));
      fa.flushMicrotasks();
      expect(done, isTrue);
      expect(forms, 0);
      expect(s.privacyOptionsRequired, isFalse);
    });
  });

  for (final mode in [_Mode.failure, _Mode.success]) {
    test('갱신 ${mode.name} 콜백이면 폼 1회, 개인정보 옵션 필요', () async {
      final s = ConsentService(info: _Info(mode), loadAndShow: loadAndShow);
      await s.gather();
      expect(forms, 1);
      expect(s.privacyOptionsRequired, isTrue);
    });
  }

  group('ATT 회귀', () {
    const att = MethodChannel('sudoku/att');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    late int attCalls;

    setUp(() {
      attCalls = 0;
      TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
      messenger.setMockMethodCallHandler(att, (call) async {
        if (call.method == 'request') attCalls++;
        return null;
      });
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
      messenger.setMockMethodCallHandler(att, null);
    });

    test('UMP 갱신이 무응답이어도 10초 뒤 ATT 를 요청한다', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      fakeAsync((fa) {
        final ads = AdMobService(
          consent: ConsentService(
            info: _Info(_Mode.silent),
            loadAndShow: loadAndShow,
          ),
        );
        unawaited(ads.warmUp());

        fa.elapse(const Duration(seconds: 9));
        fa.flushMicrotasks();
        expect(attCalls, 0);

        fa.elapse(const Duration(seconds: 2));
        fa.flushMicrotasks();
        expect(attCalls, 1);
      });
    });
  });
}
