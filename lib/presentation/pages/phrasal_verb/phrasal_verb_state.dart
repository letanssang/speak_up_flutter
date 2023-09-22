import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/phrasal_verb/phrasal_verb.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'phrasal_verb_state.freezed.dart';

@freezed
class PhrasalVerbState with _$PhrasalVerbState {
  const factory PhrasalVerbState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<PhrasalVerb> phrasalVerbs,
    @Default(0) int progress,
  }) = _PhrasalVerbState;
}
