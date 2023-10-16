import 'button_state.dart';

PronunciationAssessmentStatus getPronunciationAssessmentStatus(double score) {
  if (score >= 80) {
    return PronunciationAssessmentStatus.wellDone;
  } else if (score >= 60) {
    return PronunciationAssessmentStatus.tryAgain;
  } else {
    return PronunciationAssessmentStatus.failed;
  }
}

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

  bool canMoveToNext() {
    switch (this) {
      case PronunciationAssessmentStatus.initial:
        return false;
      case PronunciationAssessmentStatus.recording:
        return false;
      case PronunciationAssessmentStatus.inProgress:
        return false;
      case PronunciationAssessmentStatus.wellDone:
        return true;
      case PronunciationAssessmentStatus.tryAgain:
        return true;
      case PronunciationAssessmentStatus.failed:
        return true;
      default:
        return false;
    }
  }
}
