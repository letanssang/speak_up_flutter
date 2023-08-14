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

  Topic({
    required this.topicID,
    required this.topicName,
    required this.translation,
    required this.categoryID,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  factory Topic.initial() => Topic(
        topicID: 0,
        topicName: '',
        translation: '',
        categoryID: 0,
      );
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
