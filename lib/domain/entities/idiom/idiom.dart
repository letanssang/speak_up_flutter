import 'package:json_annotation/json_annotation.dart';

part 'idiom.g.dart';

@JsonSerializable()
class Idiom {
  @JsonKey(name: 'IdiomID')
  final int idiomID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'IdiomTypeID')
  final int idiomTypeId;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'DescriptionTranslation')
  final String descriptionTranslation;
  @JsonKey(name: 'AudioEndpoint')
  final String audioEndpoint;

  Idiom({
    required this.idiomID,
    required this.name,
    required this.idiomTypeId,
    required this.description,
    required this.descriptionTranslation,
    required this.audioEndpoint,
  });

  factory Idiom.fromJson(Map<String, dynamic> json) => _$IdiomFromJson(json);

  factory Idiom.initial() => Idiom(
        idiomID: 0,
        name: '',
        idiomTypeId: 0,
        description: '',
        descriptionTranslation: '',
        audioEndpoint: '',
      );

  Map<String, dynamic> toJson() => _$IdiomToJson(this);
}
