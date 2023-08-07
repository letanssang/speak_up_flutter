import 'package:json_annotation/json_annotation.dart';

part 'expression_type.g.dart';

@JsonSerializable()
class ExpressionType {
  @JsonKey(name: 'ExpressionTypeID')
  final int expressionTypeID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Translation')
  final String translation;
  @JsonKey(name: 'Description')
  final String description;
  @JsonKey(name: 'DescriptionTranslation')
  final String descriptionTranslation;
  ExpressionType({
    required this.expressionTypeID,
    required this.name,
    required this.translation,
    required this.description,
    required this.descriptionTranslation,
  });
  factory ExpressionType.fromJson(Map<String, dynamic> json) =>
      _$ExpressionTypeFromJson(json);
  factory ExpressionType.initial() => ExpressionType(
        expressionTypeID: 0,
        name: '',
        translation: '',
        description: '',
        descriptionTranslation: '',
      );
  Map<String, dynamic> toJson() => _$ExpressionTypeToJson(this);
}
