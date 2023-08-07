import 'package:json_annotation/json_annotation.dart';
part 'idiom_type.g.dart';

@JsonSerializable()
class IdiomType {
  @JsonKey(name: 'IdiomTypeID')
  final int idiomTypeID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Translation')
  final String translation;
  IdiomType({
    required this.idiomTypeID,
    required this.name,
    required this.translation,
  });
  factory IdiomType.fromJson(Map<String, dynamic> json) =>
      _$IdiomTypeFromJson(json);
  Map<String, dynamic> toJson() => _$IdiomTypeToJson(this);
}
