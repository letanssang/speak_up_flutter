import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'saved_flashcards_state.freezed.dart';

@freezed
class SavedFlashCardsState with _$SavedFlashCardsState {
  const factory SavedFlashCardsState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<FlashCard> flashCardList,
  }) = _SavedFlashCardsState;
}
