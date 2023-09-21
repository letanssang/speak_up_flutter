import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'pattern_state.freezed.dart';

@freezed
class PatternState with _$PatternState {
  const factory PatternState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<Sentence> sentenceExamples,
    @Default(false) bool isTranslated,
    @Default(false) bool isOpenedDialog,
  }) = _PatternState;
}
