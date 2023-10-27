import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/speech_sentence/speech_sentence.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';

part 'pronunciation_topic_state.freezed.dart';

@freezed
class PronunciationTopicState with _$PronunciationTopicState {
  const factory PronunciationTopicState({
    @Default([]) List<Sentence> sentences,
    @Default(PronunciationAssessmentStatus.initial)
    PronunciationAssessmentStatus pronunciationAssessmentStatus,
    SpeechSentence? speechSentence,
    String? recordPath,
    @Default(false) bool isStoppedRecording,
    @Default(0) currentIndex,
    @Default(false) isTranslatedAnswer,
  }) = _PronunciationTopicState;
}
