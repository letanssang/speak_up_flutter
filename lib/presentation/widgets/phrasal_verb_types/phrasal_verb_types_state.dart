import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'phrasal_verb_types_state.freezed.dart';

@freezed
class PhrasalVerbTypesState with _$PhrasalVerbTypesState {
  const factory PhrasalVerbTypesState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<PhrasalVerbType> phrasalVerbTypes,
  }) = _PhrasalVerbTypesState;
}
