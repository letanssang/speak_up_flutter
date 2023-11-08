import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/phoneme/phoneme.dart';
import 'package:speak_up/domain/entities/syllable/syllable.dart';

part 'speech_word.g.dart';

@JsonSerializable()
class SpeechWord {
  @JsonKey(name: 'Word')
  final String word;
  @JsonKey(name: 'Offset')
  final double offset;
  @JsonKey(name: 'Duration')
  final double duration;
  @JsonKey(name: 'Confidence')
  final double confidence;
  @JsonKey(name: 'AccuracyScore')
  final double accuracyScore;

  ///	This value indicates whether a word is omitted, inserted, or mispronounced, compared to the ReferenceText.
  ///Possible values are None, Omission, Insertion, and Mispronunciation. The error type can be Mispronunciation when the pronunciation AccuracyScore for a word is below 60.
  @JsonKey(name: 'ErrorType')
  final String errorType;
  @JsonKey(name: 'Syllables')
  final List<Syllable>? syllables;
  @JsonKey(name: 'Phonemes')
  final List<Phoneme>? phonemes;

  SpeechWord({
    required this.word,
    required this.offset,
    required this.duration,
    required this.confidence,
    required this.accuracyScore,
    required this.errorType,
    required this.syllables,
    required this.phonemes,
  });

  factory SpeechWord.fromJson(Map<String, dynamic> json) =>
      _$SpeechWordFromJson(json);

  Map<String, dynamic> toJson() => _$SpeechWordToJson(this);
}
