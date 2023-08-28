import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_display_name_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_email_use_case.dart';
import 'package:speak_up/presentation/pages/edit_profile/edit_profile_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class EditProfileViewModel extends StateNotifier<EditProfileState> {
  final IsSignedInUseCase _isSignedInUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateDisplayNameUseCase _updateDisplayNameUseCase;
  final UpdateEmailUseCase _updateEmailUseCase;

  EditProfileViewModel(
    this._getCurrentUserUseCase,
    this._isSignedInUseCase,
    this._updateDisplayNameUseCase,
    this._updateEmailUseCase,
  ) : super(const EditProfileState());

  Future<void> onSubmitted({String? name, String? email}) async {
    if (!_isSignedInUseCase.run()) return;
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    final user = _getCurrentUserUseCase.run();
    try {
      if (name != null && name != user.displayName) {
        await _updateDisplayNameUseCase.run(name);
      }
      if (email != null && email != user.email) {
        await _updateEmailUseCase.run(email);
      }
      state = state.copyWith(loadingStatus: LoadingStatus.success);
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        errorCode: e.toString(),
      );
    }
  }

  void resetError() {
    state = state.copyWith(
      loadingStatus: LoadingStatus.initial,
      errorCode: '',
    );
  }
}
