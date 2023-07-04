import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/injection/injector.dart';

final themeProvider =
    StateProvider<bool>((ref) => injector.get<GetAppThemeUseCase>().run());
