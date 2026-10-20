import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 광고 제거 권리. 생성 시 동기로 읽고, 부여만 가능하다(회수 없음).
class EntitlementStore {
  static const _key = 'ent_ads_removed_v1';

  EntitlementStore(this._prefs)
    : adsRemoved = ValueNotifier(_prefs.getBool(_key) ?? false);

  final SharedPreferences _prefs;
  final ValueNotifier<bool> adsRemoved;

  Future<void> grant() async {
    adsRemoved.value = true;
    try {
      await _prefs.setBool(_key, true);
    } catch (e) {
      debugPrint('EntitlementStore: 저장 실패 ($e)');
    }
  }
}
