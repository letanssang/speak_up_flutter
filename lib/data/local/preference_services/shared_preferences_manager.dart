import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_up/data/local/preference_services/preference_key.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

class SharedPreferencesManager {
  SharedPreferencesManager(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  ///dark mode status
  Future<void> saveIsDarkTheme({required bool param}) async =>
      _sharedPreferences.setBool(
        PreferenceKey.isDarkTheme.name,
        param,
      );

  Future<bool> removeIsDarkTheme() async => _sharedPreferences.remove(
        PreferenceKey.isDarkTheme.name,
      );

  bool? getIsDarkTheme() => _sharedPreferences.getBool(
        PreferenceKey.isDarkTheme.name,
      );

  Future<void> saveAppLanguage({required Language language}) async {
    _sharedPreferences.setString(
      PreferenceKey.language.name,
      EnumToString.convertToString(language),
    );
  }

  Language getAppLanguage() {
    final language = _sharedPreferences.getString(
      PreferenceKey.language.name,
    );
    if (language == null) {
      return Language.english;
    }
    return EnumToString.fromString(Language.values, language)!;
  }
}
