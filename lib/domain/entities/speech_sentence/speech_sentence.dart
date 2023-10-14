import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/speech_word/speech_word.dart';

part 'speech_sentence.g.dart';

@JsonSerializable()
class SpeechSentence {
  ///Pronunciation accuracy of the speech.
  /// Accuracy indicates how closely the phonemes match a native speaker's pronunciation.
  /// Syllable, word, and full text accuracy scores are aggregated from phoneme-level accuracy score, and refined with assessment objectives.
  @JsonKey(name: 'Confidence')
  final double confidence;
  @JsonKey(name: 'Lexical')
  final String lexical;
  @JsonKey(name: 'ITN')
  final String itn;
  @JsonKey(name: 'MaskedITN')
  final String maskedItn;
  @JsonKey(name: 'Display')
  final String display;
  @JsonKey(name: 'AccuracyScore')
  final double accuracyScore;

  ///Fluency of the given speech.
  /// Fluency indicates how closely the speech matches a native speaker's use of silent breaks between words.
  @JsonKey(name: 'FluencyScore')
  final double fluencyScore;

  ///Completeness of the speech, calculated by the ratio of pronounced words to the input reference text.
  @JsonKey(name: 'CompletenessScore')
  final double completenessScore;

  ///Overall score indicating the pronunciation quality of the given speech.
  /// PronScore is aggregated from AccuracyScore, FluencyScore, and CompletenessScore with weight.
  @JsonKey(name: 'PronScore')
  final double pronScore;
  @JsonKey(name: 'Words')
  final List<SpeechWord> words;

  SpeechSentence({
    required this.confidence,
    required this.lexical,
    required this.itn,
    required this.maskedItn,
    required this.display,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.pronScore,
    required this.words,
  });

  factory SpeechSentence.fromJson(Map<String, dynamic> json) =>
      _$SpeechSentenceFromJson(json);

  factory SpeechSentence.initial() => SpeechSentence(
        confidence: 0,
        lexical: '',
        itn: '',
        maskedItn: '',
        display: '',
        accuracyScore: 0,
        fluencyScore: 0,
        completenessScore: 0,
        pronScore: 0,
        words: [],
      );

  Map<String, dynamic> toJson() => _$SpeechSentenceToJson(this);
}
