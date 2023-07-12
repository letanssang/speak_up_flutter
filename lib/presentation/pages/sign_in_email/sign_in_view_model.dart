import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_email_and_password_use_case.dart';
import 'package:speak_up/presentation/pages/sign_in_email/sign_in_email_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class SignInEmailViewModel extends StateNotifier<SignInEmailState> {
  SignInEmailViewModel(this._signInWithEmailAndPassword)
      : super(const SignInEmailState());
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPassword;

  void onPasswordVisibilityPressed() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  void resetError() {
    state = state.copyWith(
      loadingStatus: LoadingStatus.initial,
      errorMessage: '',
    );
  }

  Future<void> onSignInButtonPressed(String email, String password) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.inProgress,
    );
    try {
      SignInWithEmailParams params = SignInWithEmailParams(
        email: email,
        password: password,
      );
      await _signInWithEmailAndPassword.run(params);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Invalid email',
          );
          break;
        case 'user-not-found':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'User not found',
          );
          break;
        case 'user-disabled':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'User disabled',
          );
          break;
        case 'wrong-password':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Wrong password',
          );
          break;
        default:
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Something went wrong',
          );
      }
    }
  }
}
