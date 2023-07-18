import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_language_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

final appLanguageProvider = StateProvider<Language>((ref) {
  return injector.get<GetAppLanguageUseCase>().run();
});
