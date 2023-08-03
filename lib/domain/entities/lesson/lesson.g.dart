// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
      lessonID: json['LessonID'] as int,
      name: json['Name'] as String,
      translation: json['Translation'] as String,
      description: json['Description'] as String,
      descriptionTranslation: json['DescriptionTranslation'] as String,
      imageURL: json['ImageURL'] as String,
    );

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'LessonID': instance.lessonID,
      'Name': instance.name,
      'Translation': instance.translation,
      'Description': instance.description,
      'DescriptionTranslation': instance.descriptionTranslation,
      'ImageURL': instance.imageURL,
    };
