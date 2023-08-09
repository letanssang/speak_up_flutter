import 'package:json_annotation/json_annotation.dart';
part 'phrasal_verb.g.dart';

@JsonSerializable()
class PhrasalVerb {
  @JsonKey(name: 'PhrasalVerbID')
  final int phrasalVerbID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'PhrasalVerbTypeID')
  final int phrasalVerbTypeID;
  @JsonKey(name: 'DescriptionTranslation')
  final String descriptionTranslation;
  @JsonKey(name: 'Description')
  final String description;
  PhrasalVerb({
    required this.phrasalVerbID,
    required this.name,
    required this.phrasalVerbTypeID,
    required this.descriptionTranslation,
    required this.description,
  });
  factory PhrasalVerb.fromJson(Map<String, dynamic> json) =>
      _$PhrasalVerbFromJson(json);
  Map<String, dynamic> toJson() => _$PhrasalVerbToJson(this);
}
