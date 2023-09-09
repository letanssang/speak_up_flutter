class SentencePattern {
  final int patternID;
  final String name;
  final String dialogue;

  SentencePattern({
    required this.patternID,
    required this.name,
    required this.dialogue,
  });

  factory SentencePattern.initial() => SentencePattern(
        patternID: 0,
        name: '',
        dialogue: '',
      );
}
