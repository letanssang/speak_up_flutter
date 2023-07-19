import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(false) bool isCurrentPasswordVisible,
    @Default(false) bool isNewPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
  }) = _ChangePasswordState;
}
