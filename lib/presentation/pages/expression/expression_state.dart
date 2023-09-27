import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'expression_state.freezed.dart';

@freezed
class ExpressionState with _$ExpressionState {
  const factory ExpressionState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<Sentence> sentences,
  }) = _ExpressionState;
}
