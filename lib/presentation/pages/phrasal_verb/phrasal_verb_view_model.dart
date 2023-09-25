import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_phrasal_verb_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PhrasalVerbViewModel extends StateNotifier<PhrasalVerbState> {
  final GetPhrasalVerbListByTypeUseCase _getPhrasalVerbListByTypeUseCase;
  final GetPhrasalVerbProgressUseCase _getPhrasalVerbProgressUseCase;

  PhrasalVerbViewModel(
    this._getPhrasalVerbListByTypeUseCase,
    this._getPhrasalVerbProgressUseCase,
  ) : super(const PhrasalVerbState());

  Future<void> fetchPhrasalVerbList(int type) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final phrasalVerbList = await _getPhrasalVerbListByTypeUseCase.run(type);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        phrasalVerbs: phrasalVerbList,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> updateProgressState(int idiomTypeID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final progress = await _getPhrasalVerbProgressUseCase.run(idiomTypeID);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        progress: progress,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
