import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IdiomViewModel extends StateNotifier<IdiomState> {
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;
  IdiomViewModel(
    this._getIdiomListByTypeUseCase,
  ) : super(const IdiomState());
  Future<void> fetchIdiomList(int type) async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    try {
      final idiomList = await _getIdiomListByTypeUseCase.run(type);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        idioms: idiomList,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
