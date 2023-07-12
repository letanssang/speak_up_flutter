import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isDarkMode,
    @Default(false) bool enableNotification,
    @Default(false) bool isSigningOut,
  }) = _ProfileState;
}
