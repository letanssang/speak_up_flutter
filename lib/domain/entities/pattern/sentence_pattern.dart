class SentencePattern {
  final int patternID;
  final String name;
  final String dialogue;
  final String description;
  final String descriptionTranslation;
  final String? youtubeVideoID;

  SentencePattern({
    required this.patternID,
    required this.name,
    this.dialogue = '',
    this.description = '',
    this.descriptionTranslation = '',
    this.youtubeVideoID,
  });

  factory SentencePattern.initial() => SentencePattern(
        patternID: 0,
        name: '',
      );
}
