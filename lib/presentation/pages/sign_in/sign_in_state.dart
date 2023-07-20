import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'sign_in_state.freezed.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default('') String errorCode,
  }) = _SignInState;
}
