import 'package:speak_up/domain/entities/idiom/idiom.dart';

class FlashCard {
  String frontText;
  String backText;
  String? backTranslation;

  FlashCard(
      {required this.frontText, required this.backText, this.backTranslation});

  factory FlashCard.fromIdiom(Idiom idiom) {
    return FlashCard(
        frontText: idiom.name,
        backText: idiom.description,
        backTranslation: idiom.descriptionTranslation);
  }
}
