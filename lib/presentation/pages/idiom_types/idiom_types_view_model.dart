import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/entities/quiz/quiz.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_type_list_use_case.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IdiomTypesViewModel extends StateNotifier<IdiomTypesState> {
  final GetIdiomTypeListUseCase _getIdiomTypeListUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;

  IdiomTypesViewModel(this._getIdiomTypeListUseCase,
      this._getCurrentUserUseCase, this._getIdiomListByTypeUseCase)
      : super(const IdiomTypesState());

  Future<void> fetchIdiomTypeList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final idiomTypes = await _getIdiomTypeListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        idiomTypes: idiomTypes,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<List<FlashCard>> getFlashCardByIdiomTypeID(int idiomTypeID) async {
    try {
      final currentUser = _getCurrentUserUseCase.run();
      final idiomList = await _getIdiomListByTypeUseCase.run(idiomTypeID);
      final flashCards = idiomList
          .map((e) => FlashCard.fromIdiom(e, currentUser.uid))
          .toList();
      //add empty flash card to the end of the list
      flashCards.add(FlashCard.initial());
      return flashCards;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<Quiz>> getQuizzesByIdiomTypeID(int idiomTypeID) async {
    try {
      final idiomList = await _getIdiomListByTypeUseCase.run(idiomTypeID);

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

      return quizzes;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
