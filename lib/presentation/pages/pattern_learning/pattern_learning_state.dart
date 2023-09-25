import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'pattern_learning_state.freezed.dart';

@freezed
class PatternLearningState with _$PatternLearningState {
  const factory PatternLearningState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(0) int currentPage,
    @Default(0) totalPage,
    @Default([]) List<Sentence> exampleSentences,
    @Default(ButtonState.normal) ButtonState recordButtonState,
    @Default(ButtonState.normal) ButtonState nextButtonState,
    @Default(false) isAnimating,
    String? recordPath,
  }) = _PatternLearningState;
}
