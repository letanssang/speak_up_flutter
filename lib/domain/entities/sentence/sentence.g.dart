// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sentence _$SentenceFromJson(Map<String, dynamic> json) => Sentence(
      sentenceID: json['SentenceId'] as int,
      text: json['Text'] as String,
      translation: json['Translation'] as String,
      audioEndpoint: json['AudioEndpoint'] as String,
      topicID: json['TopicId'] as int,
      sortOrder: json['SortOrder'] as int,
      type: json['Type'] as int,
    );

Map<String, dynamic> _$SentenceToJson(Sentence instance) => <String, dynamic>{
      'SentenceId': instance.sentenceID,
      'Text': instance.text,
      'Translation': instance.translation,
      'AudioEndpoint': instance.audioEndpoint,
      'TopicId': instance.topicID,
      'SortOrder': instance.sortOrder,
      'Type': instance.type,
    };
