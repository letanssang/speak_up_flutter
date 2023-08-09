// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      topicID: json['TopicID'] as int,
      topicName: json['TopicName'] as String,
      translation: json['Translation'] as String,
      categoryID: json['CategoryID'] as int,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'TopicID': instance.topicID,
      'TopicName': instance.topicName,
      'Translation': instance.translation,
      'CategoryID': instance.categoryID,
    };
