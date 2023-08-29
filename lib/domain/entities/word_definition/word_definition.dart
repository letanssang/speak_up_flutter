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
  final List<String>? partOf;
  final List<String>? hasParts;
  final List<String>? instanceOf;
  final List<String>? hasInstances;
  final List<String>? similarTo;
  final List<String>? also;
  final List<String>? entails;
  final List<String>? substanceOf;
  final List<String>? hasSubstances;
  final List<String>? inCategory;
  final List<String>? hasCategories;
  final List<String>? usageOf;
  final List<String>? hasUsages;
  final List<String>? inRegion;
  final List<String>? regionOf;
  final List<String>? pertainsTo;
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
    this.partOf,
    this.hasParts,
    this.instanceOf,
    this.hasInstances,
    this.similarTo,
    this.also,
    this.entails,
    this.substanceOf,
    this.hasSubstances,
    this.inCategory,
    this.hasCategories,
    this.usageOf,
    this.hasUsages,
    this.inRegion,
    this.regionOf,
    this.pertainsTo,
    this.derivation,
    this.examples,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) =>
      _$WordDefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$WordDefinitionToJson(this);
}
