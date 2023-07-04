import 'package:speak_up/data/services/preference_services/shared_preferences_manager.dart';

class AccountSettingsRepository {
  AccountSettingsRepository(this._sharedPreferencesManager);

  final SharedPreferencesManager _sharedPreferencesManager;

  bool getThemeData() {
    final isDarkTheme = _sharedPreferencesManager.getIsDarkTheme();
    return isDarkTheme ?? false;
  }

  Future<void> switchAppThemeMode(bool value) async {
    await _sharedPreferencesManager.saveIsDarkTheme(param: value);
  }
}
