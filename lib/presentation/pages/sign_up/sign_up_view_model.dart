import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_display_name_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/save_user_data_use_case.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

import 'sign_up_state.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  final CreateUserWithEmailAndPasswordUseCase _createUserWithEmailAndPassword;
  final SaveUserDataUseCase _saveUserDataUseCase;
  final UpdateDisplayNameUseCase _updateDisplayNameUseCase;
  final FirebaseAuth _firebaseAuth;

  SignUpViewModel(
      this._createUserWithEmailAndPassword,
      this._saveUserDataUseCase,
      this._updateDisplayNameUseCase,
      this._firebaseAuth)
      : super(const SignUpState());

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

  Future<void> onSignUpButtonPressed(
      String email, String password, String name) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );
    try {
      CreateUserWithEmailParams params = CreateUserWithEmailParams(
        email: email,
        password: password,
      );
      final userCredential = await _createUserWithEmailAndPassword.run(params);
      if (userCredential.user != null) {
        _updateDisplayNameUseCase.run(name);
        _saveUserDataUseCase.run(_firebaseAuth.currentUser!);
      }
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.code,
      );
    } on FirebaseException catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.code,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.toString(),
      );
      debugPrint(e.toString());
    }
  }
}
