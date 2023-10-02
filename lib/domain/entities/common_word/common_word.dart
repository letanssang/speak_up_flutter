class CommonWord {
  final int commonWordID;
  final String commonWord;
  final String translation;
  final String partOfSpeech;
  final String level;
  final int type;

  CommonWord({
    required this.commonWordID,
    required this.commonWord,
    required this.translation,
    required this.partOfSpeech,
    required this.level,
    required this.type,
  });

  factory CommonWord.initial() {
    return CommonWord(
      commonWordID: 0,
      commonWord: '',
      translation: '',
      partOfSpeech: '',
      level: '',
      type: 0,
    );
  }
}
