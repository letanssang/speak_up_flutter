class Lesson {
  final int lessonID;
  final String name;
  final String translation;
  final String description;
  final String descriptionTranslation;
  final String imageURL;

  Lesson({
    required this.lessonID,
    required this.name,
    required this.translation,
    required this.description,
    required this.descriptionTranslation,
    required this.imageURL,
  });

  factory Lesson.initial() => Lesson(
        lessonID: 0,
        name: '',
        translation: '',
        description: '',
        descriptionTranslation: '',
        imageURL: '',
      );
}
