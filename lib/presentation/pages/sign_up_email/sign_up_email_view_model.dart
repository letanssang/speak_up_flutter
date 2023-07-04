import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sign_up_email_state.dart';

class SignUpEmailViewModel extends StateNotifier<SignUpEmailState> {
  SignUpEmailViewModel() : super(const SignUpEmailState());
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

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    const String regex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final RegExp regExp = RegExp(regex);
    if (!regExp.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateUserName(String? userName) {
    if (userName == null || userName.isEmpty) {
      return 'User name is required';
    }
    if (userName.length < 6) {
      return 'User name must be at least 6 characters';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    const String regex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$';
    final RegExp regExp = RegExp(regex);
    if (!regExp.hasMatch(password)) {
      return 'Password must contain at least 1 uppercase letter, 1 lowercase letter and 1 number';
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    if (confirmPassword != state.password) {
      return 'Password not match';
    }
    return null;
  }

  Future<void> onSignUpButtonPressed(formKey) async {
    if (formKey.currentState!.validate()) {
      debugPrint('User name: ${state.userName}');
      debugPrint('Email: ${state.email}');
      debugPrint('Password: ${state.password}');
    }
  }
}
