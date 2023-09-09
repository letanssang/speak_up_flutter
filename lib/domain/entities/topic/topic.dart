class Topic {
  final int topicID;
  final String topicName;
  final String translation;
  final int categoryID;

  Topic({
    required this.topicID,
    required this.topicName,
    required this.translation,
    required this.categoryID,
  });

  factory Topic.initial() => Topic(
        topicID: 0,
        topicName: '',
        translation: '',
        categoryID: 0,
      );
}
