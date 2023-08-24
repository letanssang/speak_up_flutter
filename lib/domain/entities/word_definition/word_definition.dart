import 'package:json_annotation/json_annotation.dart';
part 'word_definition.g.dart';

@JsonSerializable()
class WordDefinition {
  @JsonKey(name: 'definition')
  final String? definition;
  @JsonKey(name: 'partOfSpeech')
  final String? partOfSpeech;
  @JsonKey(name: 'synonyms')
  final List<String>? synonyms;
  @JsonKey(name: 'typeOf')
  final List<String>? typeOf;
  @JsonKey(name: 'derivation')
  final List<String>? derivation;
  WordDefinition({
    this.definition,
    this.partOfSpeech,
    this.synonyms,
    this.typeOf,
    this.derivation,
  });
  factory WordDefinition.fromJson(Map<String, dynamic> json) =>
      _$WordDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$WordDefinitionToJson(this);
}
