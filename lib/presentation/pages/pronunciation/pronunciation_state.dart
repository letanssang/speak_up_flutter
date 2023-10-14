import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/speech_sentence/speech_sentence.dart';
import 'package:speak_up/domain/entities/word/word.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assesment_status.dart';

part 'pronunciation_state.freezed.dart';

@freezed
class PronunciationState with _$PronunciationState {
  const factory PronunciationState({
    @Default([]) List<Word> wordList,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(PronunciationAssessmentStatus.initial)
    PronunciationAssessmentStatus pronunciationAssessmentStatus,
    SpeechSentence? speechSentence,
    String? recordPath,
    @Default(0) currentIndex,
  }) = _PronunciationState;
}
