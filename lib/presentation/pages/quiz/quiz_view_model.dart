import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';

class QuizViewModel extends StateNotifier<QuizState> {
  final SpeakFromTextUseCase _speakFromTextUseCase;
  final pageViewController = PageController(
    initialPage: 0,
  );

  QuizViewModel(
    this._speakFromTextUseCase,
  ) : super(const QuizState());

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

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }
}
