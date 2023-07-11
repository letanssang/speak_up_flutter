import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

import 'sign_up_state.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  final CreateUserWithEmailAndPasswordUseCase _createUserWithEmailAndPassword;

  SignUpViewModel(
    this._createUserWithEmailAndPassword,
  ) : super(const SignUpState());

  void onPasswordChanged(String password) {
    state = state.copyWith(
      password: password,
    );
  }

  void onUserNameChanged(String userName) {
    state = state.copyWith(
      userName: userName,
    );
  }

  void onEmailChanged(String email) {
    state = state.copyWith(
      email: email,
    );
  }

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

  Future<void> onSignUpButtonPressed() async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.inProgress,
    );
    try {
      CreateUserWithEmailParams params = CreateUserWithEmailParams(
        email: state.email,
        password: state.password,
      );
      await _createUserWithEmailAndPassword.run(params);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Email address is already in use',
          );
          break;
        case 'invalid-email':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Email address is invalid',
          );
          break;
        case 'weak-password':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Password is too weak',
          );
          break;
        case 'operation-not-allowed':
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Operation is not allowed',
          );
          break;
        default:
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Something went wrong',
          );
          break;
      }
      debugPrint(e.message);
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorMessage: 'Something went wrong',
      );
      debugPrint(e.toString());
    }
  }
}
