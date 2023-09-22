class PhrasalVerb {
  final int phrasalVerbID;
  final String name;
  final int phrasalVerbTypeID;
  final String descriptionTranslation;
  final String description;

  PhrasalVerb({
    required this.phrasalVerbID,
    required this.name,
    required this.phrasalVerbTypeID,
    required this.descriptionTranslation,
    required this.description,
  });

  PhrasalVerb.initial()
      : phrasalVerbID = 0,
        name = '',
        phrasalVerbTypeID = 0,
        descriptionTranslation = '',
        description = '';
}
