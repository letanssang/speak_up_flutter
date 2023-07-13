// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      json['ID'] as int,
      json['Topic Name'] as String,
      json['Category ID'] as int,
      json['Category Name'] as String,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'ID': instance.id,
      'Topic Name': instance.name,
      'Category ID': instance.categoryID,
      'Category Name': instance.category,
    };
