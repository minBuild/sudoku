import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  static const _instantCheckKey = 'settings_instant_check_v1';
  static const _mistakeHintKey = 'hint_mistake_kept_shown_v1';
  static const _saveIncompatibleKey = 'notice_save_incompatible_shown_v1';
  static const _soundKey = 'settings_sound_v1';

  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  bool get instantCheckDefault => _prefs.getBool(_instantCheckKey) ?? true;
  Future<void> setInstantCheckDefault(bool v) =>
      _prefs.setBool(_instantCheckKey, v);

  bool get soundEnabled => _prefs.getBool(_soundKey) ?? true;
  Future<void> setSoundEnabled(bool v) => _prefs.setBool(_soundKey, v);

  bool get mistakeHintShown => _prefs.getBool(_mistakeHintKey) ?? false;
  Future<void> markMistakeHintShown() => _prefs.setBool(_mistakeHintKey, true);

  bool get saveIncompatibleNoticeShown =>
      _prefs.getBool(_saveIncompatibleKey) ?? false;
  Future<void> markSaveIncompatibleNoticeShown() =>
      _prefs.setBool(_saveIncompatibleKey, true);
}
