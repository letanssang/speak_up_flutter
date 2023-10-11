import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/speech_sentence/speech_sentence.dart';

part 'azure_speech_response.g.dart';

@JsonSerializable()
class AzureSpeechResponse {
  @JsonKey(name: 'RecognitionStatus')
  final String recognitionStatus;
  @JsonKey(name: 'DisplayText')
  final String displayText;
  @JsonKey(name: 'Offset')
  final double offset;
  @JsonKey(name: 'Duration')
  final double duration;
  @JsonKey(name: 'NBest')
  final List<SpeechSentence> nBest;

  AzureSpeechResponse({
    required this.recognitionStatus,
    required this.displayText,
    required this.offset,
    required this.duration,
    required this.nBest,
  });

  factory AzureSpeechResponse.fromJson(Map<String, dynamic> json) =>
      _$AzureSpeechResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AzureSpeechResponseToJson(this);
}
