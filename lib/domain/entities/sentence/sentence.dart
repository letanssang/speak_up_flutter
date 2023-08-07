import 'package:json_annotation/json_annotation.dart';

part 'sentence.g.dart';

@JsonSerializable()
class Sentence {
  @JsonKey(name: 'SentenceID')
  final int sentenceID;
  @JsonKey(name: 'Text')
  final String text;
  @JsonKey(name: 'Translation')
  final String translation;
  @JsonKey(name: 'AudioEndpoint')
  final String audioEndpoint;
  @JsonKey(name: 'ParentID')
  final int parentID;
  @JsonKey(name: 'ParentType')
  final int parentType;

  Sentence({
    required this.sentenceID,
    required this.text,
    required this.translation,
    required this.audioEndpoint,
    required this.parentID,
    required this.parentType,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) =>
      _$SentenceFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceToJson(this);
}
