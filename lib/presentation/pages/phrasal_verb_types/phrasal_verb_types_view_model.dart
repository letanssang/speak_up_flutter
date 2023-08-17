import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phrasal_verb_type_list_use_case.dart';
import 'package:speak_up/presentation/pages/phrasal_verb_types/phrasal_verb_types_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PhrasalVerbTypesViewModel extends StateNotifier<PhrasalVerbTypesState> {
  final GetPhrasalVerbTypeListUseCase _getPhrasalVerbTypeListUseCase;
  PhrasalVerbTypesViewModel(
    this._getPhrasalVerbTypeListUseCase,
  ) : super(const PhrasalVerbTypesState());
  Future<void> getPhrasalVerbList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    try {
      final phrasalVerbTypes = await _getPhrasalVerbTypeListUseCase.run();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        phrasalVerbTypes: phrasalVerbTypes,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
