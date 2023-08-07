import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/pattern_lesson_detail/pattern_lesson_detail_state.dart';

class PatternLessonDetailViewModel
    extends StateNotifier<PatternLessonDetailState> {
  final GetSentencePatternListUseCase _getSentencePatternListUseCase;
  PatternLessonDetailViewModel(
    this._getSentencePatternListUseCase,
  ) : super(const PatternLessonDetailState());
  Future<void> fetchSentencePatternList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
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
