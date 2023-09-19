import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_cards_state.freezed.dart';

@freezed
class FlashCardsState with _$FlashCardsState {
  const factory FlashCardsState({
    @Default(0) int currentIndex,
    @Default(false) bool isAnimating,
  }) = _FlashCardsState;
}
