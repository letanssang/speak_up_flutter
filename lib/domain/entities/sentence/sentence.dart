import 'package:json_annotation/json_annotation.dart';

part 'sentence.g.dart';

@JsonSerializable()
class Sentence {
  @JsonKey(name: 'SentenceId')
  final int sentenceID;
  @JsonKey(name: 'Text')
  final String text;
  @JsonKey(name: 'Translation')
  final String translation;
  @JsonKey(name: 'AudioEndpoint')
  final String audioEndpoint;
  @JsonKey(name: 'TopicId')
  final int topicID;
  @JsonKey(name: 'SortOrder')
  final int sortOrder;
  @JsonKey(name: 'Type')
  final int type;

  Sentence({
    required this.sentenceID,
    required this.text,
    required this.translation,
    required this.audioEndpoint,
    required this.topicID,
    required this.sortOrder,
    required this.type,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) =>
      _$SentenceFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceToJson(this);
}
