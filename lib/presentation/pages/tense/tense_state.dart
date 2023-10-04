import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/tense_form/tense_form.dart';
import 'package:speak_up/domain/entities/tense_usage/tense_usage.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'tense_state.freezed.dart';

@freezed
class TenseState with _$TenseState {
  const factory TenseState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<TenseForm> tenseForms,
    @Default([]) List<TenseUsage> tenseUsages,
  }) = _TenseState;
}
