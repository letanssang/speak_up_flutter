import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/speech_sentence/speech_sentence.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';

part 'pronunciation_practice_state.freezed.dart';

@freezed
class PronunciationPracticeState with _$PronunciationPracticeState {
  const factory PronunciationPracticeState({
    @Default([]) List<Sentence> sentences,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(PronunciationAssessmentStatus.initial)
    PronunciationAssessmentStatus pronunciationAssessmentStatus,
    SpeechSentence? speechSentence,
    String? recordPath,
    @Default(false) bool isStoppedRecording,
    @Default(0) currentIndex,
  }) = _PronunciationPracticeState;
}
