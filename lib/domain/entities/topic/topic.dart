import 'package:json_annotation/json_annotation.dart';
part 'topic.g.dart';

@JsonSerializable()
class Topic {
  @JsonKey(name: 'ID')
  final int id;
  @JsonKey(name: 'Topic Name')
  final String name;
  @JsonKey(name: 'Category ID')
  final int categoryID;
  @JsonKey(name: 'Category Name')
  final String category;
  Topic(
    this.id,
    this.name,
    this.categoryID,
    this.category,
  );
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
