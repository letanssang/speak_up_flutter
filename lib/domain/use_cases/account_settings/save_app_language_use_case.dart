import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

class SaveAppLanguageUseCase implements FutureUseCase<Language, void> {
  @override
  Future<void> run(Language input) {
    return injector.get<AccountSettingsRepository>().saveAppLanguage(input);
  }
}
