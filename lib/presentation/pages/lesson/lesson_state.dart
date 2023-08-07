import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'lesson_state.freezed.dart';

@freezed
class LessonState with _$LessonState {
  const factory LessonState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
  }) = _LessonState;
}
