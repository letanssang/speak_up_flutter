import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_state.dart';

class ChangePasswordViewModel extends StateNotifier<ChangePasswordState> {
  ChangePasswordViewModel() : super(const ChangePasswordState());

  void onCurrentPasswordVisibilityPressed() {
    state = state.copyWith(
      isCurrentPasswordVisible: !state.isCurrentPasswordVisible,
    );
  }

  void onNewPasswordVisibilityPressed() {
    state = state.copyWith(
      isNewPasswordVisible: !state.isNewPasswordVisible,
    );
  }

  void onConfirmPasswordVisibilityPressed() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }
}
