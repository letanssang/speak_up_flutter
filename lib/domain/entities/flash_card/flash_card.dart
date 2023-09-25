import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/phrasal_verb/phrasal_verb.dart';
part 'flash_card.g.dart';

@JsonSerializable()
class FlashCard {
  @JsonKey(name: 'FlashCardID')
  int flashcardID;
  @JsonKey(name: 'FrontText')
  String frontText;
  @JsonKey(name: 'BackText')
  String backText;
  @JsonKey(name: 'BackTranslation')
  String? backTranslation;
  @JsonKey(name: 'UserID')
  String userID;

  FlashCard({
    required this.flashcardID,
    required this.frontText,
    required this.backText,
    this.backTranslation,
    required this.userID,
  });

  factory FlashCard.fromIdiom(Idiom idiom, String userID) {
    return FlashCard(
      flashcardID: idiom.idiomID,
      frontText: idiom.name,
      backText: idiom.description,
      backTranslation: idiom.descriptionTranslation,
      userID: userID,
    );
  }
  factory FlashCard.fromPhrasalVerb(PhrasalVerb phrasalVerb, String userID) {
    return FlashCard(
      flashcardID: phrasalVerb.phrasalVerbID,
      frontText: phrasalVerb.name,
      backText: phrasalVerb.description,
      backTranslation: phrasalVerb.descriptionTranslation,
      userID: userID,
    );
  }

  factory FlashCard.initial() {
    return FlashCard(flashcardID: 0, frontText: '', backText: '', userID: '');
  }

  factory FlashCard.fromJson(Map<String, dynamic> json) =>
      _$FlashCardFromJson(json);

  Map<String, dynamic> toJson() => _$FlashCardToJson(this);
}
