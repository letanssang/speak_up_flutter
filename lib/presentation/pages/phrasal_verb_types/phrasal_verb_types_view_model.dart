import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/entities/quiz/quiz.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_type_list_use_case.dart';
import 'package:speak_up/presentation/pages/phrasal_verb_types/phrasal_verb_types_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PhrasalVerbTypesViewModel extends StateNotifier<PhrasalVerbTypesState> {
  final GetPhrasalVerbTypeListUseCase _getPhrasalVerbTypeListUseCase;
  final GetPhrasalVerbListByTypeUseCase _getPhrasalVerbListByTypeUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  PhrasalVerbTypesViewModel(
    this._getPhrasalVerbTypeListUseCase,
    this._getPhrasalVerbListByTypeUseCase,
    this._getCurrentUserUseCase,
  ) : super(const PhrasalVerbTypesState());

  Future<void> getPhrasalVerbList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final phrasalVerbTypes = await _getPhrasalVerbTypeListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        phrasalVerbTypes: phrasalVerbTypes,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<List<FlashCard>> getFlashCardByPhrasalVerbTypeID(
      int phrasalVerbTypeID) async {
    try {
      final currentUser = _getCurrentUserUseCase.run();
      final phrasalVerbList =
          await _getPhrasalVerbListByTypeUseCase.run(phrasalVerbTypeID);
      final flashCards = phrasalVerbList
          .map((e) => FlashCard.fromPhrasalVerb(e, currentUser.uid))
          .toList();
      //add empty flash card to the end of the list
      flashCards.add(FlashCard.initial());
      return flashCards;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Quiz>> getQuizzesByPhrasalVerbTypeID(
      int phrasalVerbTypeID) async {
    try {
      final phrasalVerbList =
          await _getPhrasalVerbListByTypeUseCase.run(phrasalVerbTypeID);

      final List<Quiz> quizzes = phrasalVerbList.map((phrasalVerb) {
        final correctAnswer = phrasalVerb.descriptionTranslation;
        final randomPhrasalVerbs =
            List<String>.from(phrasalVerbList.map((item) {
          return item.descriptionTranslation;
        }))
              ..remove(correctAnswer);
        randomPhrasalVerbs.shuffle();
        final wrongAnswers = randomPhrasalVerbs.take(3).toList();

        final allAnswers = [correctAnswer, ...wrongAnswers];
        allAnswers.shuffle();

        return Quiz(
          question: phrasalVerb.name,
          answers: allAnswers,
          correctAnswerIndex: allAnswers.indexOf(correctAnswer),
        );
      }).toList();

      return quizzes;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
