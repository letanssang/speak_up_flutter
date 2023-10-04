import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/tense/tense.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'tenses_state.freezed.dart';

@freezed
class TensesState with _$TensesState {
  const factory TensesState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<Tense> tenses,
  }) = _TensesState;
}
