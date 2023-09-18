import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/quiz/quiz.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';

class QuizViewModel extends StateNotifier<QuizState> {
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;
  final SpeakFromTextUseCase _speakFromTextUseCase;

  QuizViewModel(
    this._getIdiomListByTypeUseCase,
    this._speakFromTextUseCase,
  ) : super(const QuizState());

  void init(LessonType lessonType, dynamic parent) {
    state = state.copyWith(lessonType: lessonType, parent: parent);
  }

  Future<void> fetchQuizzes() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
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

      final List<Quiz> quizzes = idiomList.map((idiom) {
        final correctAnswer = idiom.descriptionTranslation;
        final randomIdioms = List<String>.from(idiomList.map((item) {
          return item.descriptionTranslation;
        }))
          ..remove(correctAnswer);
        randomIdioms.shuffle();
        final wrongAnswers = randomIdioms.take(3).toList();

        final allAnswers = [correctAnswer, ...wrongAnswers];
        allAnswers.shuffle();

        return Quiz(
          question: idiom.name,
          answers: allAnswers,
          correctAnswerIndex: allAnswers.indexOf(correctAnswer),
        );
      }).toList();

      state = state.copyWith(
        quizzes: quizzes,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> onSelectedAnswerOption(
      int correctAnswerIndex, int chosenAnswerIndex) async {
    int correctAnswerNumber = state.correctAnswerNumber;
    if (correctAnswerIndex == chosenAnswerIndex) {
      correctAnswerNumber++;
    }
    state = state.copyWith(
        quizAnswerCardStatus: QuizAnswerCardStatus.after,
        chosenAnswerIndex: chosenAnswerIndex,
        correctAnswerNumber: correctAnswerNumber);
  }

  void onNextQuestion() {
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      quizAnswerCardStatus: QuizAnswerCardStatus.before,
    );
  }

  Future<void> speak(String text) async {
    await _speakFromTextUseCase.run(text);
  }
}
