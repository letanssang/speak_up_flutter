import 'package:json_annotation/json_annotation.dart';
part 'phrasal_verb_type.g.dart';

@JsonSerializable()
class PhrasalVerbType {
  @JsonKey(name: 'PhrasalVerbTypeID')
  final int phrasalVerbTypeID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Translation')
  final String translation;
  PhrasalVerbType({
    required this.phrasalVerbTypeID,
    required this.name,
    required this.translation,
  });
  factory PhrasalVerbType.fromJson(Map<String, dynamic> json) =>
      _$PhrasalVerbTypeFromJson(json);
  Map<String, dynamic> toJson() => _$PhrasalVerbTypeToJson(this);
}
