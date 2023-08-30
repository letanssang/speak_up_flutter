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
  @JsonKey(name: 'Example')
  final String example;
  @JsonKey(name: 'ExamplePronunciation')
  final String examplePronunciation;
  Phonetic({
    required this.phoneticID,
    required this.phonetic,
    required this.phoneticType,
    required this.youtubeVideoId,
    required this.description,
    required this.example,
    required this.examplePronunciation,
  });
  factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);
  factory Phonetic.initial() => Phonetic(
        phoneticID: 0,
        phonetic: '',
        phoneticType: 0,
        youtubeVideoId: '',
        description: '',
        example: '',
        examplePronunciation: '',
      );
  Map<String, dynamic> toJson() => _$PhoneticToJson(this);
}
