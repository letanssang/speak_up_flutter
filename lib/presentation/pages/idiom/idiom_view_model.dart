import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_idiom_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IdiomViewModel extends StateNotifier<IdiomState> {
  final GetIdiomListByTypeUseCase _getIdiomListByTypeUseCase;
  final GetIdiomProgressUseCase _getIdiomProgressUseCase;

  IdiomViewModel(
    this._getIdiomListByTypeUseCase,
    this._getIdiomProgressUseCase,
  ) : super(const IdiomState());

  Future<void> fetchIdiomList(int type) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
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

  Future<void> updateProgressState(int idiomTypeID) async {
    final progress = await _getIdiomProgressUseCase.run(idiomTypeID);
    state = state.copyWith(progress: progress);
  }
}
