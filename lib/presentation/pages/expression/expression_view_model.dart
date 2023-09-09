import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/presentation/pages/expression/expression_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ExpressionViewModel extends StateNotifier<ExpressionState> {
  final GetExpressionListByTypeUseCase _getExpressionListByTypeUseCase;

  ExpressionViewModel(
    this._getExpressionListByTypeUseCase,
  ) : super(const ExpressionState());

  Future<void> fetchExpressionList(int expressionType) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );
    try {
      final expressions =
          await _getExpressionListByTypeUseCase.run(expressionType);
      state = state.copyWith(
        expressions: expressions,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
      );
    }
  }
}
