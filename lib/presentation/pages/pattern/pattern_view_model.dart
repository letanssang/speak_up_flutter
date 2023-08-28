import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_pattern_use_case.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PatternViewModel extends StateNotifier<PatternState> {
  final GetSentenceListFromPatternUseCase _getSentenceListFromPatternUseCase;
  PatternViewModel(
    this._getSentenceListFromPatternUseCase,
  ) : super(const PatternState());
  Future<void> fetchExampleList(int patternId) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );
    try {
      final sentenceExamples =
          await _getSentenceListFromPatternUseCase.run(patternId);
      state = state.copyWith(
        sentenceExamples: sentenceExamples,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
      );
    }
  }
}
