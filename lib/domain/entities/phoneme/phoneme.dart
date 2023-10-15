import 'package:json_annotation/json_annotation.dart';

part 'phoneme.g.dart';

@JsonSerializable()
class Phoneme {
  @JsonKey(name: 'Phoneme')
  final String phoneme;
  @JsonKey(name: 'Offset')
  final double offset;
  @JsonKey(name: 'Duration')
  final double duration;
  @JsonKey(name: 'AccuracyScore')
  final double accuracyScore;

  Phoneme({
    required this.phoneme,
    required this.offset,
    required this.duration,
    required this.accuracyScore,
  });

  factory Phoneme.fromJson(Map<String, dynamic> json) =>
      _$PhonemeFromJson(json);

  Map<String, dynamic> toJson() => _$PhonemeToJson(this);
}
