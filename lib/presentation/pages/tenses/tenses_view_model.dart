import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_tense_list_use_case.dart';
import 'package:speak_up/presentation/pages/tenses/tenses_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class TensesViewModel extends StateNotifier<TensesState> {
  TensesViewModel(
    this._getTenseListUseCase,
  ) : super(const TensesState());
  final GetTenseListUseCase _getTenseListUseCase;
  Future<void> getTenseList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final tenses = await _getTenseListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        tenses: tenses,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
