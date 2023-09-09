class Idiom {
  final int idiomID;
  final String name;
  final int idiomTypeID;
  final String description;
  final String descriptionTranslation;
  final String audioEndpoint;

  Idiom({
    required this.idiomID,
    required this.name,
    required this.idiomTypeID,
    required this.description,
    required this.descriptionTranslation,
    required this.audioEndpoint,
  });

  factory Idiom.initial() => Idiom(
        idiomID: 0,
        name: '',
        idiomTypeID: 0,
        description: '',
        descriptionTranslation: '',
        audioEndpoint: '',
      );
}
