class Phonetic {
  final int phoneticID;
  final String phonetic;
  final int phoneticType;
  final String youtubeVideoId;
  final String description;
  final Map<String, String> example;

  Phonetic({
    required this.phoneticID,
    required this.phonetic,
    required this.phoneticType,
    required this.youtubeVideoId,
    required this.description,
    required this.example,
  });

  factory Phonetic.initial() => Phonetic(
        phoneticID: 0,
        phonetic: '',
        phoneticType: 0,
        youtubeVideoId: '',
        description: '',
        example: {},
      );
}
