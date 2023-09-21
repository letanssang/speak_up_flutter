import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/word/word.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'pronunciation_state.freezed.dart';

@freezed
class PronunciationState with _$PronunciationState {
  const factory PronunciationState({
    @Default([]) List<Word> wordList,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(ButtonState.normal) ButtonState recordButtonState,
    String? recordPath,
    @Default(0) currentIndex,
  }) = _PronunciationState;
}