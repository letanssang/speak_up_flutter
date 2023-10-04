import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_tense_form_list_from_tense_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_tense_usage_list_from_tense_use_case.dart';
import 'package:speak_up/presentation/pages/tense/tense_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class TenseViewModel extends StateNotifier<TenseState> {
  TenseViewModel(
    this._getTenseFormListFromTenseUseCase,
    this._getTenseUsageListFromTenseUseCase,
  ) : super(const TenseState());
  final GetTenseFormListFromTenseUseCase _getTenseFormListFromTenseUseCase;
  final GetTenseUsageListFromTenseUseCase _getTenseUsageListFromTenseUseCase;

  Future<void> getTenseData(int tenseID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final tenseForms = await _getTenseFormListFromTenseUseCase.run(tenseID);
      final tenseUsages = await _getTenseUsageListFromTenseUseCase.run(tenseID);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        tenseForms: tenseForms,
        tenseUsages: tenseUsages,
      );
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
