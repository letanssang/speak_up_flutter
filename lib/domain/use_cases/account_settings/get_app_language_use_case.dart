import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

import '../../../data/repositories/account_settings/account_settings_repository.dart';

class GetAppLanguageUseCase implements OutputUseCase<Language> {
  @override
  Language run() {
    return injector.get<AccountSettingsRepository>().getAppLanguage();
  }
}
