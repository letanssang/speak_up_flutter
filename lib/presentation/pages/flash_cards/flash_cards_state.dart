import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'flash_cards_state.freezed.dart';

@freezed
class FlashCardsState with _$FlashCardsState {
  const factory FlashCardsState({
    @Default([]) List<FlashCard> flashCards,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(FlashCardType.idiom) FlashCardType flashCardType,
    dynamic parent,
    @Default(0) int currentIndex,
  }) = _FlashCardsState;
}
