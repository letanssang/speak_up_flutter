import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'idiom_learning_state.freezed.dart';

@freezed
class IdiomLearningState with _$IdiomLearningState {
  const factory IdiomLearningState({
    required Idiom idiom,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
  }) = _IdiomLearningState;
}
