import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default('') String errorCode,
  }) = _EditProfileState;
}
