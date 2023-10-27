class Sentence {
  final int sentenceID;
  final String text;
  final String translation;
  final String audioEndpoint;
  final int parentID;
  final int parentType;

  Sentence({
    required this.sentenceID,
    required this.text,
    required this.translation,
    required this.audioEndpoint,
    required this.parentID,
    required this.parentType,
  });

  Sentence.initial()
      : sentenceID = 0,
        text = '',
        translation = '',
        audioEndpoint = '',
        parentID = 0,
        parentType = 0;
}
