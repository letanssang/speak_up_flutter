class ExpressionType {
  final int expressionTypeID;
  final String name;
  final String translation;
  final String description;
  final String descriptionTranslation;

  ExpressionType({
    required this.expressionTypeID,
    required this.name,
    required this.translation,
    required this.description,
    required this.descriptionTranslation,
  });

  factory ExpressionType.initial() => ExpressionType(
        expressionTypeID: 0,
        name: '',
        translation: '',
        description: '',
        descriptionTranslation: '',
      );
}
