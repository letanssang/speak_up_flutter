import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'phonetic.g.dart';

@JsonSerializable()
class Phonetic {
  @JsonKey(name: 'PhoneticID')
  final int phoneticID;
  @JsonKey(name: 'Phonetic')
  final String phonetic;
  @JsonKey(name: 'PhoneticType')
  final int phoneticType;
  @JsonKey(name: 'YoutubeVideoID')
  final String youtubeVideoId;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'Example', fromJson: _exampleFromJson, toJson: _exampleToJson)
  final Map<String, String> example;

  Phonetic({
    required this.phoneticID,
    required this.phonetic,
    required this.phoneticType,
    required this.youtubeVideoId,
    required this.description,
    required this.example,
  });

  factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);

  factory Phonetic.initial() => Phonetic(
        phoneticID: 0,
        phonetic: '',
        phoneticType: 0,
        youtubeVideoId: '',
        description: '',
        example: {},
      );

  Map<String, dynamic> toJson() => _$PhoneticToJson(this);

  static Map<String, String> _exampleFromJson(dynamic json) {
    if (json is String) {
      final Map<String, dynamic> jsonMap = jsonDecode(json);
      final Map<String, String> exampleMap = {};
      jsonMap.forEach((key, value) {
        if (value is String) {
          exampleMap[key] = value;
        }
      });
      return exampleMap;
    }
    return {};
  }

  // Create a method for serializing 'example'
  static Map<String, dynamic> _exampleToJson(Map<String, String> example) {
    return example;
  }
}
