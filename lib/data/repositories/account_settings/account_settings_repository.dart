import 'package:speak_up/data/local/preference_services/shared_preferences_manager.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

class AccountSettingsRepository {
  AccountSettingsRepository(this._sharedPreferencesManager);

  final SharedPreferencesManager _sharedPreferencesManager;

  bool getThemeData() {
    final isDarkTheme = _sharedPreferencesManager.getIsDarkTheme();
    return isDarkTheme ?? false;
  }

  Future<void> switchAppTheme(bool value) async {
    await _sharedPreferencesManager.saveIsDarkTheme(param: value);
  }

  Future<void> saveAppLanguage(Language language) async {
    await _sharedPreferencesManager.saveAppLanguage(language: language);
  }

  Language getAppLanguage() {
    return _sharedPreferencesManager.getAppLanguage();
  }
}
