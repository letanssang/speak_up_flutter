class PhrasalVerbType {
  final int phrasalVerbTypeID;
  final String name;
  final String translation;

  PhrasalVerbType({
    required this.phrasalVerbTypeID,
    required this.name,
    required this.translation,
  });

  factory PhrasalVerbType.initial() => PhrasalVerbType(
        phrasalVerbTypeID: 0,
        name: '',
        translation: '',
      );
}
