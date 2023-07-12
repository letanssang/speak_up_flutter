import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_out_use_case.dart';
import 'package:speak_up/presentation/pages/profile/profile_state.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final GetAppThemeUseCase _getAppThemeUseCase;
  final SwitchAppThemeUseCase _switchAppThemeUseCase;
  final SignOutUseCase _signOutUseCase;

  ProfileViewModel(this._getAppThemeUseCase, this._switchAppThemeUseCase,
      this._signOutUseCase)
      : super(const ProfileState());

  bool getThemeData() {
    final isDarkMode = _getAppThemeUseCase.run();
    state = state.copyWith(isDarkMode: isDarkMode);
    return isDarkMode;
  }

  void changeThemeData(bool isDarkMode) {
    _switchAppThemeUseCase.run(isDarkMode);
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  void switchNotification(bool enableNotification) {
    state = state.copyWith(enableNotification: enableNotification);
  }

  Future<void> signOut() async {
    state = state.copyWith(isSigningOut: true);
    await _signOutUseCase.run();
  }
}
