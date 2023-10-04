import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class SwitchAppThemeUseCase implements UseCase<bool, void> {
  @override
  Future<void> run(bool input) async {
    await injector.get<AccountSettingsRepository>().switchAppTheme(input);
  }
}
