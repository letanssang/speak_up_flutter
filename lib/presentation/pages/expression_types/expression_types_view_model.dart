import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_type_list_use_case.dart';
import 'package:speak_up/presentation/pages/expression_types/expression_types_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ExpressionTypesViewModel extends StateNotifier<ExpressionTypesState> {
  final GetExpressionTypeListUseCase _getExpressionTypeListUseCase;

  ExpressionTypesViewModel(this._getExpressionTypeListUseCase)
      : super(const ExpressionTypesState());

  Future<void> fetchExpressionTypeList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final expressionTypes = await _getExpressionTypeListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        expressionTypes: expressionTypes,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
