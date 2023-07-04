import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/data/services/preference_services/shared_preferences_manager.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/injection/injector.dart';

class AppModules {
  static Future<void> inject() async {
    // SharedPreferences client
    injector.registerSingletonAsync<SharedPreferences>(() async {
      return SharedPreferences.getInstance();
    });

    // SharedPreferences manager
    injector.registerLazySingleton<SharedPreferencesManager>(
        () => SharedPreferencesManager(injector.get<SharedPreferences>()));

    // Account settings repository
    injector.registerLazySingleton<AccountSettingsRepository>(() =>
        AccountSettingsRepository(injector.get<SharedPreferencesManager>()));

    // Get app theme use case
    injector
        .registerLazySingleton<GetAppThemeUseCase>(() => GetAppThemeUseCase());
    // Switch app theme use case
    injector.registerLazySingleton<SwitchAppThemeUseCase>(
        () => SwitchAppThemeUseCase());
  }
}
