import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_up/data/services/preference_services/preference_key.dart';

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
}
