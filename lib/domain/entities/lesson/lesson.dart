import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson {
  @JsonKey(name: 'LessonID')
  final int lessonID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Translation')
  final String translation;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'DescriptionTranslation')
  final String descriptionTranslation;
  @JsonKey(name: 'ImageURL')
  final String imageURL;

  Lesson({
    required this.lessonID,
    required this.name,
    required this.translation,
    required this.description,
    required this.descriptionTranslation,
    required this.imageURL,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  factory Lesson.initial() => Lesson(
        lessonID: 0,
        name: '',
        translation: '',
        description: '',
        descriptionTranslation: '',
        imageURL: '',
      );
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
