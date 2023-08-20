import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/quiz/quiz.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class QuizViewModel extends StateNotifier<QuizState> {
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;

  QuizViewModel(
    this._getIdiomListByTypeUseCase,
  ) : super(const QuizState());

  void init(LessonType lessonType, dynamic parent) {
    state = state.copyWith(lessonType: lessonType, parent: parent);
  }

  Future<void> fetchQuizzes() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    switch (state.lessonType) {
      case LessonType.idiom:
        await _fetchIdiomQuizzes();
        break;
      default:
        break;
    }
  }

  Future<void> _fetchIdiomQuizzes() async {
    try {
      final idiomList =
          await _getIdiomListByTypeUseCase.run(state.parent.idiomTypeID);
      final List<Quiz> quizzes = [
        Quiz(
          question: idiomList[0].name,
          answers: [
            idiomList[0].descriptionTranslation,
            idiomList[1].descriptionTranslation,
            idiomList[2].descriptionTranslation,
            idiomList[3].descriptionTranslation,
          ],
          correctAnswerIndex: 0,
        ),
        Quiz(
          question: idiomList[1].name,
          answers: [
            idiomList[0].descriptionTranslation,
            idiomList[1].descriptionTranslation,
            idiomList[2].descriptionTranslation,
            idiomList[3].descriptionTranslation,
          ],
          correctAnswerIndex: 1,
        ),
      ];
      state = state.copyWith(
        quizzes: quizzes,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
