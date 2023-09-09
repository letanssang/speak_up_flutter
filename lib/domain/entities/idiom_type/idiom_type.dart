class IdiomType {
  final int idiomTypeID;
  final String name;
  final String translation;
  IdiomType({
    required this.idiomTypeID,
    required this.name,
    required this.translation,
  });
  factory IdiomType.initial() => IdiomType(
        idiomTypeID: 0,
        name: '',
        translation: '',
      );
}
