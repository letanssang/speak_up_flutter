import 'package:freezed_annotation/freezed_annotation.dart';
part 'expression_learning_state.freezed.dart';

@freezed
class ExpressionLearningState with _$ExpressionLearningState {
  const factory ExpressionLearningState({
    @Default(0) int currentPage,
    @Default(false) isAnimating,
    String? recordPath,
  }) = _ExpressionLearningState;
}
