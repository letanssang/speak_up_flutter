import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_expression_done_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

import 'expression_type_state.dart';

class ExpressionTypeViewModel extends StateNotifier<ExpressionTypeState> {
  final GetExpressionListByTypeUseCase _getExpressionListByTypeUseCase;
  final GetExpressionDoneListUseCase _getExpressionDoneListUseCase;
  final SpeakFromTextUseCase _speakFromTextUseCase;

  ExpressionTypeViewModel(
    this._getExpressionListByTypeUseCase,
    this._getExpressionDoneListUseCase,
    this._speakFromTextUseCase,
  ) : super(const ExpressionTypeState());

  Future<void> fetchExpressionList(int expressionType) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );
    try {
      final expressions =
          await _getExpressionListByTypeUseCase.run(expressionType);
      state = state.copyWith(
        expressions: expressions,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
      );
    }
  }

  void speak(String text) {
    _speakFromTextUseCase.run(text);
  }

  void toggleTranslate() {
    state = state.copyWith(
      isTranslated: !state.isTranslated,
    );
  }

  Future<void> fetchExpressionDoneList() async {
    state = state.copyWith(progressLoadingStatus: LoadingStatus.loading);
    try {
      final expressionDoneList = await _getExpressionDoneListUseCase.run();
      // update state.isDoneList based on foreach and contains
      final expressions = state.expressions;
      List<bool> isDoneList = [];
      for (int i = 0; i < expressions.length; i++) {
        if (expressionDoneList.contains(expressions[i].expressionID)) {
          isDoneList.add(true);
        } else {
          isDoneList.add(false);
        }
      }
      state = state.copyWith(
        progressLoadingStatus: LoadingStatus.success,
        isDoneList: isDoneList,
      );
    } catch (e) {
      state = state.copyWith(progressLoadingStatus: LoadingStatus.error);
    }
  }
}
