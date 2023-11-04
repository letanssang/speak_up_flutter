import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';

class QuizViewModel extends StateNotifier<QuizState> {
  final SpeakFromTextUseCase _speakFromTextUseCase;
  final PlayCongratsAudioUseCase _playCongratsAudioUseCase;
  final PlayCompleteAudioUseCase _playCompleteAudioUseCase;
  final pageViewController = PageController(
    initialPage: 0,
  );

  QuizViewModel(
    this._speakFromTextUseCase,
    this._playCongratsAudioUseCase,
    this._playCompleteAudioUseCase,
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

  void playCongratsAudio() {
    _playCongratsAudioUseCase.run();
  }

  void playCompleteAudio() {
    _playCompleteAudioUseCase.run();
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }
}
