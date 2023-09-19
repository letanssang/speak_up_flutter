import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/use_cases/firestore/add_flash_card_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_state.dart';
import 'package:swipable_stack/swipable_stack.dart';

class FlashCardsViewModel extends StateNotifier<FlashCardsState> {
  final SpeakFromTextUseCase _speakFromTextUseCase;
  final AddFlashCardUseCase _addFlashCardUseCase;
  final swipableStackController = SwipableStackController();

  FlashCardsViewModel(
    this._speakFromTextUseCase,
    this._addFlashCardUseCase,
  ) : super(const FlashCardsState());

  void init(String text) {
    swipableStackController.addListener(() {
      state = state.copyWith(
        currentIndex: swipableStackController.currentIndex,
      );
    });
    speakFromText(text);
  }

  void nextFlashCard(SwipeDirection direction) {
    if (state.isAnimating) return;
    state = state.copyWith(currentIndex: state.currentIndex + 1);
  }

  void updateAnimating(bool isAnimating) {
    state = state.copyWith(isAnimating: isAnimating);
  }

  Future<void> speakFromText(String text) async {
    await _speakFromTextUseCase.run(text);
  }

  Future<void> addFlashCard(FlashCard flashCard) async {
    try {
      await _addFlashCardUseCase.run(flashCard);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    swipableStackController.dispose();
    super.dispose();
  }
}
