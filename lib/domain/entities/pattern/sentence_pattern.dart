import 'package:json_annotation/json_annotation.dart';

part 'sentence_pattern.g.dart';

@JsonSerializable()
class SentencePattern {
  @JsonKey(name: 'PatternID')
  final int patternID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Dialogue')
  final String dialogue;
  SentencePattern({
    required this.patternID,
    required this.name,
    required this.dialogue,
  });
  factory SentencePattern.fromJson(Map<String, dynamic> json) =>
      _$SentencePatternFromJson(json);
  factory SentencePattern.initial() => SentencePattern(
        patternID: 0,
        name: '',
        dialogue: '',
      );
  Map<String, dynamic> toJson() => _$SentencePatternToJson(this);
}
