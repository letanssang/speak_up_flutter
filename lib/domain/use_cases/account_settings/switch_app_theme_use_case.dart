import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class SwitchAppThemeUseCase extends UseCase<bool, void> {
  @override
  Future<void> run(bool param) async {
    await injector.get<AccountSettingsRepository>().switchAppTheme(param);
  }
  }