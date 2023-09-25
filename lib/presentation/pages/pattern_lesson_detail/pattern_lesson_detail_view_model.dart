import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_pattern_done_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PatternLessonDetailViewModel
    extends StateNotifier<PatternLessonDetailState> {
  final GetSentencePatternListUseCase _getSentencePatternListUseCase;
  final GetPatternDoneListUseCase _getPatternDoneListUseCase;

  PatternLessonDetailViewModel(
    this._getSentencePatternListUseCase,
    this._getPatternDoneListUseCase,
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

  Future<void> fetchPatternDoneList() async {
    state = state.copyWith(progressLoadingStatus: LoadingStatus.loading);
    try {
      final patternDoneList = await _getPatternDoneListUseCase.run();
      // update state.isDoneList based on foreach and contains
      final patterns = state.sentencePatterns;
      List<bool> isDoneList = [];
      for (int i = 0; i < patterns.length; i++) {
        if (patternDoneList.contains(patterns[i].patternID)) {
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
