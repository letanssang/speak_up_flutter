import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'expression_type_state.freezed.dart';

@freezed
class ExpressionTypeState with _$ExpressionTypeState {
  const factory ExpressionTypeState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(LoadingStatus.initial) LoadingStatus progressLoadingStatus,
    @Default([]) List<Expression> expressions,
    @Default([]) List<bool> isDoneList,
    @Default(false) isTranslated,
  }) = _ExpressionTypeState;
}
