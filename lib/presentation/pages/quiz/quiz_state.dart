import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/quiz/quiz.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';

part 'quiz_state.freezed.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState({
    @Default([]) List<Quiz> quizzes,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(LessonType.idiom) LessonType lessonType,
    dynamic parent,
    @Default(0) int currentIndex,
    @Default(QuizAnswerCardStatus.before) quizAnswerCardStatus,
    @Default(0) chosenAnswerIndex,
  }) = _QuizState;
}
