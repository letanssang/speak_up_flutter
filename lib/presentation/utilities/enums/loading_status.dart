import 'package:speak_up/presentation/utilities/enums/button_state.dart';

enum LoadingStatus {
  initial,
  loading,
  success,
  error,
}

extension LoadingStatusExtension on LoadingStatus {
  ButtonState get buttonState {
    switch (this) {
      case LoadingStatus.initial:
      case LoadingStatus.success:
      case LoadingStatus.error:
        return ButtonState.normal;
      case LoadingStatus.loading:
        return ButtonState.loading;
    }
  }
}
