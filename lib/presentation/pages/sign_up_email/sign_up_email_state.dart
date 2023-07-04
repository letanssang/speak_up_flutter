import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_email_state.freezed.dart';

@freezed
class SignUpEmailState with _$SignUpEmailState {
  const factory SignUpEmailState({
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isSignUpButtonEnabled,
    @Default('') String userName,
    @Default('') String email,
    @Default('') String password,
  }) = _SignUpEmailState;
}
