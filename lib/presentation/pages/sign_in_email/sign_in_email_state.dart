import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'sign_in_email_state.freezed.dart';

@freezed
class SignInEmailState with _$SignInEmailState {
  const factory SignInEmailState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(true) bool isPasswordVisible,
    @Default('') String errorCode,
  }) = _SignInEmailState;
}
