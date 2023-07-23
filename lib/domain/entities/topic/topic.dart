import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  @JsonKey(name: 'TopicID')
  final int topicID;
  @JsonKey(name: 'TopicName')
  final String topicName;
  @JsonKey(name: 'Translation')
  final String translation;
  @JsonKey(name: 'CategoryID')
  final int categoryID;
  @JsonKey(name: 'QAPairCount')
  final int pairCount;

  Topic({
    required this.topicID,
    required this.topicName,
    required this.translation,
    required this.categoryID,
    required this.pairCount,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
