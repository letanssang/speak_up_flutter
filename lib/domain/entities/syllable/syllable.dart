import 'package:json_annotation/json_annotation.dart';

part 'syllable.g.dart';

@JsonSerializable()
class Syllable {
  @JsonKey(name: 'Syllable')
  final String syllable;
  @JsonKey(name: 'Offset')
  final double offset;
  @JsonKey(name: 'Duration')
  final double duration;
  @JsonKey(name: 'AccuracyScore')
  final double accuracyScore;

  Syllable({
    required this.syllable,
    required this.offset,
    required this.duration,
    required this.accuracyScore,
  });

  factory Syllable.fromJson(Map<String, dynamic> json) =>
      _$SyllableFromJson(json);

  Map<String, dynamic> toJson() => _$SyllableToJson(this);
}
