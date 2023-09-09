class Word {
  final int wordID;
  final int phoneticID;
  final String word;
  final String translation;
  final String pronunciation;

  // example: desk {"d": 30, "e": 3, "s": 25, "k": 22}
  final Map<String, int> phoneticComponents;

  Word({
    required this.wordID,
    required this.phoneticID,
    required this.word,
    required this.translation,
    required this.pronunciation,
    required this.phoneticComponents,
  });
}
