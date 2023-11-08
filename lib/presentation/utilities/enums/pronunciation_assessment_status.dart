import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String getAssistantText(BuildContext context) {
    switch (this) {
      case PronunciationAssessmentStatus.initial:
        return AppLocalizations.of(context)!.tapToRecord;
      case PronunciationAssessmentStatus.recording:
        return AppLocalizations.of(context)!.iAmListening;
      case PronunciationAssessmentStatus.inProgress:
        return AppLocalizations.of(context)!.waitAMoment;
      case PronunciationAssessmentStatus.wellDone:
        return AppLocalizations.of(context)!.youSpeakLikeANativeSpeaker;
      case PronunciationAssessmentStatus.tryAgain:
        return AppLocalizations.of(context)!.tryAgainYouCanDoIt;
      case PronunciationAssessmentStatus.failed:
        return AppLocalizations.of(context)!.sorryIDidntCatchThat;
      default:
        return AppLocalizations.of(context)!.tapToRecord;
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
