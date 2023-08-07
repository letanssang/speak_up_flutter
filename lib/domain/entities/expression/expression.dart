import 'package:json_annotation/json_annotation.dart';

part 'expression.g.dart';

@JsonSerializable()
class Expression {
  @JsonKey(name: 'ExpressionID')
  final int expressionID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'ExpressionTypeID')
  final int expressionTypeID;
  @JsonKey(name: 'Translation')
  final String translation;
  Expression({
    required this.expressionID,
    required this.name,
    required this.expressionTypeID,
    required this.translation,
  });
  factory Expression.fromJson(Map<String, dynamic> json) =>
      _$ExpressionFromJson(json);
  Map<String, dynamic> toJson() => _$ExpressionToJson(this);
}
