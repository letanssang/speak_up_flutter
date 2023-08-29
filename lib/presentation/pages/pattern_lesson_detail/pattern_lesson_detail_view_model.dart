import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PatternLessonDetailViewModel
    extends StateNotifier<PatternLessonDetailState> {
  final GetSentencePatternListUseCase _getSentencePatternListUseCase;
  PatternLessonDetailViewModel(
    this._getSentencePatternListUseCase,
  ) : super(const PatternLessonDetailState());
  Future<void> fetchSentencePatternList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final sentencePatterns = await _getSentencePatternListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        sentencePatterns: sentencePatterns,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
