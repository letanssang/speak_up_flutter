import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'expression_types_state.freezed.dart';

@freezed
class ExpressionTypesState with _$ExpressionTypesState {
  const factory ExpressionTypesState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<ExpressionType> expressionTypes,
  }) = _ExpressionTypesState;
}
