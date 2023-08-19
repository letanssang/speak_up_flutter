import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_state.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class FlashCardsViewModel extends StateNotifier<FlashCardsState> {
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;
  final SpeakFromTextUseCase _speakFromTextUseCase;

  FlashCardsViewModel(
    this._getIdiomListByTypeUseCase,
    this._speakFromTextUseCase,
  ) : super(const FlashCardsState());

  void init(FlashCardType flashCardType, dynamic parent) {
    state = state.copyWith(flashCardType: flashCardType, parent: parent);
  }

  Future<void> fetchFlashCards() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    switch (state.flashCardType) {
      case FlashCardType.idiom:
        await _fetchIdiomFlashCards();
        break;
      default:
        break;
    }
  }

  Future<void> _fetchIdiomFlashCards() async {
    try {
      final idiomList =
          await _getIdiomListByTypeUseCase.run(state.parent.idiomTypeID);
      final flashCards = idiomList.map((e) => FlashCard.fromIdiom(e)).toList();
      state = state.copyWith(
        flashCards: flashCards,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  void updateCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> speakFromText(String text) async {
    await _speakFromTextUseCase.run(text);
  }
}
