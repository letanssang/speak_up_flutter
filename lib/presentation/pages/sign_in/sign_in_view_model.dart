import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_goole_use_case.dart';
import 'package:speak_up/presentation/pages/sign_in/sign_in_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class SignInViewModel extends StateNotifier<SignInState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  SignInViewModel(this._signInWithGoogleUseCase) : super(const SignInState());
  void resetError() {
    state = state.copyWith(
      loadingStatus: LoadingStatus.initial,
      errorMessage: '',
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    await _signInWithGoogleUseCase.run();
    try {
      _signInWithGoogleUseCase.run();
      state = state.copyWith(loadingStatus: LoadingStatus.success);
    } on PlatformException catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorMessage: e.toString(),
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
