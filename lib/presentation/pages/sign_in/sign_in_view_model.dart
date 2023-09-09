import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_google_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/save_user_data_use_case.dart';
import 'package:speak_up/presentation/pages/sign_in/sign_in_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class SignInViewModel extends StateNotifier<SignInState> {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SaveUserDataUseCase _saveUserDataUseCase;

  SignInViewModel(this._signInWithGoogleUseCase, this._saveUserDataUseCase)
      : super(const SignInState());

  void resetError() {
    state = state.copyWith(
      loadingStatus: LoadingStatus.initial,
      errorCode: '',
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    await _signInWithGoogleUseCase.run();
    try {
      final userCredential = await _signInWithGoogleUseCase.run();
      if (userCredential.user != null) {
        _saveUserDataUseCase.run(userCredential.user!);
      }
      state = state.copyWith(loadingStatus: LoadingStatus.success);
    } on PlatformException catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.code,
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
    }
  }
}
