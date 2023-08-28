import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/reauthenticate_with_credential_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_password_use_case.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ChangePasswordViewModel extends StateNotifier<ChangePasswordState> {
  final IsSignedInUseCase _isSignedInUseCase;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final ReAuthenticateWithCredentialUseCase
      _reAuthenticateWithCredentialUseCase;

  ChangePasswordViewModel(
    this._isSignedInUseCase,
    this._updatePasswordUseCase,
    this._reAuthenticateWithCredentialUseCase,
  ) : super(const ChangePasswordState());

  void onPasswordVisibilityPressed() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  Future<void> onSubmitted(String currentPassword, String newPassword) async {
    if (_isSignedInUseCase.run()) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.loading,
      );
      try {
        await _reAuthenticateWithCredentialUseCase.run(currentPassword);
        await _updatePasswordUseCase.run(newPassword);
        state = state.copyWith(
          loadingStatus: LoadingStatus.success,
        );
      } on FirebaseAuthException catch (e) {
        state = state.copyWith(
          errorCode: e.code,
          loadingStatus: LoadingStatus.error,
        );
      } catch (e) {
        state = state.copyWith(
          errorCode: e.toString(),
          loadingStatus: LoadingStatus.error,
        );
      }
    }
  }

  void resetError() {
    state = state.copyWith(
      errorCode: '',
      loadingStatus: LoadingStatus.initial,
    );
  }
}
