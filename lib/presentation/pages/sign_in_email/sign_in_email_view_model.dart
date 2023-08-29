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
      errorCode: '',
    );
  }

  Future<void> onSignInButtonPressed(String email, String password) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
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
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.code,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.toString(),
      );
    }
  }
}
