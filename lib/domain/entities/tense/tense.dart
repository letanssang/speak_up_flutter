class Tense {
  final int tenseID;
  final String tense;
  final String translation;
  final String signalWords;

  Tense({
    required this.tenseID,
    required this.tense,
    required this.translation,
    required this.signalWords,
  });

  factory Tense.initial() => Tense(
        tenseID: 0,
        tense: '',
        translation: '',
        signalWords: '',
      );
}
