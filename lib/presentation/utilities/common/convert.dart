import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';

String formatIndexToString(int number) {
  number++;
  if (number < 10) {
    return '0$number';
  } else {
    return number.toString();
  }
}

List<FlashCard> convertIdiomsToFlashCards(List<Idiom> idioms) {
  List<FlashCard> flashCards = [];
  for (var idiom in idioms) {
    flashCards.add(FlashCard.fromIdiom(idiom));
  }
  return flashCards;
}
