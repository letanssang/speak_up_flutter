import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'sign_up_email_state.freezed.dart';

@freezed
class SignUpEmailState with _$SignUpEmailState {
  const factory SignUpEmailState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(true) bool isPasswordVisible,
    @Default(false) bool isSignUpButtonEnabled,
    @Default('') String userName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String errorMessage,
  }) = _SignUpEmailState;
}
