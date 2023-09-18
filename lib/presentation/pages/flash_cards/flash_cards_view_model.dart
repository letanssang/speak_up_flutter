import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_state.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:swipable_stack/swipable_stack.dart';

class FlashCardsViewModel extends StateNotifier<FlashCardsState> {
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;
  final SpeakFromTextUseCase _speakFromTextUseCase;
  late final SwipableStackController swipableStackController;

  FlashCardsViewModel(
    this._getIdiomListByTypeUseCase,
    this._speakFromTextUseCase,
  ) : super(const FlashCardsState());

  void init(LessonType lessonType, dynamic parent) {
    state = state.copyWith(lessonType: lessonType, parent: parent);
    swipableStackController = SwipableStackController();
    swipableStackController.addListener(() {
      state = state.copyWith(
        currentIndex: swipableStackController.currentIndex,
      );
      print(swipableStackController.currentIndex);
    });
  }

  Future<void> fetchFlashCards() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    switch (state.lessonType) {
      case LessonType.idiom:
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
      //add empty flash card to the end of the list
      flashCards.add(FlashCard.initial());
      state = state.copyWith(
        flashCards: flashCards,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  void nextFlashCard(SwipeDirection direction) {
    if (state.isAnimating) return;
    state = state.copyWith(currentIndex: state.currentIndex + 1);
    print('nextFlashCard: ${state.currentIndex}');
  }

  void updateAnimating(bool isAnimating) {
    state = state.copyWith(isAnimating: isAnimating);
  }

  Future<void> speakFromText(String text) async {
    await _speakFromTextUseCase.run(text);
  }

  @override
  void dispose() {
    swipableStackController.dispose();
    super.dispose();
  }
}
