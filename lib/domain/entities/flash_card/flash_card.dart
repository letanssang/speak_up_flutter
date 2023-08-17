import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';

class FlashCard {
  String frontText;
  String? audioUrl;
  String backText;
  String? backTranslation;
  FlashCard(
      {required this.frontText,
      this.audioUrl,
      required this.backText,
      this.backTranslation});
  factory FlashCard.fromIdiom(Idiom idiom) {
    final audioUrl = idiomAudioURL + idiom.audioEndpoint + audioExtension;
    return FlashCard(
        frontText: idiom.name,
        audioUrl: audioUrl,
        backText: idiom.description,
        backTranslation: idiom.descriptionTranslation);
  }
}
