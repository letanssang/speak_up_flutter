import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

import 'sign_up_email_state.dart';

class SignUpEmailViewModel extends StateNotifier<SignUpEmailState> {
  final CreateUserWithEmailAndPasswordUseCase _createUserWithEmailAndPassword;

  SignUpEmailViewModel(
    this._createUserWithEmailAndPassword,
  ) : super(const SignUpEmailState());

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

  Future<void> onSignUpButtonPressed(formKey) async {
    if (formKey.currentState!.validate()) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.inProgress,
      );
      try {
        await _createUserWithEmailAndPassword.run(
          email: state.email,
          password: state.password,
        );
        state = state.copyWith(
          loadingStatus: LoadingStatus.success,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Email address is already in use',
          );
        } else {
          state = state.copyWith(
            loadingStatus: LoadingStatus.error,
            errorMessage: 'Something went wrong',
          );
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

}
