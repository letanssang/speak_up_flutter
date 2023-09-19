import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';

part 'quiz_state.freezed.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState({
    @Default(0) int currentIndex,
    @Default(QuizAnswerCardStatus.before) quizAnswerCardStatus,
    @Default(0) chosenAnswerIndex,
    @Default(0) correctAnswerNumber,
  }) = _QuizState;
}
