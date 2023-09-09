import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_type_list_use_case.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IdiomTypesViewModel extends StateNotifier<IdiomTypesState> {
  final GetIdiomTypeListUseCase _getIdiomTypeListUseCase;

  IdiomTypesViewModel(this._getIdiomTypeListUseCase)
      : super(const IdiomTypesState());

  Future<void> fetchIdiomTypeList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final idiomTypes = await _getIdiomTypeListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        idiomTypes: idiomTypes,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
