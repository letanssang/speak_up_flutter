import 'package:json_annotation/json_annotation.dart';

part 'word_definition.g.dart';

@JsonSerializable()
class WordDefinition {
  @JsonKey(name: 'definition')
  final String? definition;
  final String? partOfSpeech;
  final List<String>? synonyms;
  final List<String>? antonyms;
  final List<String>? typeOf;
  final List<String>? hasTypes;
  final List<String>? memberOf;
  final List<String>? hasMembers;
  final List<String>? derivation;
  final List<String>? examples;

  WordDefinition({
    this.definition,
    this.partOfSpeech,
    this.synonyms,
    this.antonyms,
    this.typeOf,
    this.hasTypes,
    this.memberOf,
    this.hasMembers,
    this.derivation,
    this.examples,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) =>
      _$WordDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$WordDefinitionToJson(this);
}
