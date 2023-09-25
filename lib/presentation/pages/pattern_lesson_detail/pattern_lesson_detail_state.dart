import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'pattern_lesson_detail_state.freezed.dart';

@freezed
class PatternLessonDetailState with _$PatternLessonDetailState {
  const factory PatternLessonDetailState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<SentencePattern> sentencePatterns,
    @Default([]) List<bool> isDoneList,
    @Default(LoadingStatus.initial) LoadingStatus progressLoadingStatus,
  }) = _PatternLessonDetailState;
}
