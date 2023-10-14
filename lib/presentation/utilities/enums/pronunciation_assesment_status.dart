import 'button_state.dart';

enum PronunciationAssessmentStatus {
  initial,
  recording,
  inProgress,
  wellDone,
  tryAgain,
  failed,
}

extension PronunciationAssessmentStatusExtension
    on PronunciationAssessmentStatus {
  ButtonState getButtonState() {
    switch (this) {
      case PronunciationAssessmentStatus.initial:
        return ButtonState.normal;
      case PronunciationAssessmentStatus.recording:
        return ButtonState.loading;
      case PronunciationAssessmentStatus.inProgress:
        return ButtonState.normal;
      case PronunciationAssessmentStatus.wellDone:
        return ButtonState.normal;
      case PronunciationAssessmentStatus.tryAgain:
        return ButtonState.normal;
      case PronunciationAssessmentStatus.failed:
        return ButtonState.normal;
      default:
        return ButtonState.normal;
    }
  }

  String getAssistantText() {
    switch (this) {
      case PronunciationAssessmentStatus.initial:
        return 'Tap to record';
      case PronunciationAssessmentStatus.recording:
        return 'I am listening...';
      case PronunciationAssessmentStatus.inProgress:
        return 'Wait a moment';
      case PronunciationAssessmentStatus.wellDone:
        return 'You speak like a native speaker!';
      case PronunciationAssessmentStatus.tryAgain:
        return 'Try again! You can do it!';
      case PronunciationAssessmentStatus.failed:
        return 'Sorry, I can\'t hear you.';
      default:
        return 'Tap to record';
    }
  }
}
