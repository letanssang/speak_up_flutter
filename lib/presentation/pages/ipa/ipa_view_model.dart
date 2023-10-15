import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phonetic_list_use_case.dart';
import 'package:speak_up/presentation/pages/ipa/ipa_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

import '../../../domain/use_cases/firestore/progress/get_phonetic_done_list_use_case.dart';

class IpaViewModel extends StateNotifier<IpaState> {
  final GetPhoneticListUseCase _getPhoneticListUseCase;
  final GetPhoneticDoneListUseCase _getPhoneticDoneListUseCase;

  IpaViewModel(
    this._getPhoneticListUseCase,
    this._getPhoneticDoneListUseCase,
  ) : super(const IpaState());

  Future<void> getPhoneticList() async {
    try {
      state = state.copyWith(loadingStatus: LoadingStatus.loading);
      final phonetics = await _getPhoneticListUseCase.run();
      // vowels has phoneticType = 1
      final vowels =
          phonetics.where((element) => element.phoneticType == 1).toList();
      // consonants has phoneticType = 2
      final consonants =
          phonetics.where((element) => element.phoneticType == 2).toList();
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        vowels: vowels,
        consonants: consonants,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> fetchPhoneticDoneList() async {
    state = state.copyWith(progressLoadingStatus: LoadingStatus.loading);
    try {
      final phoneticDoneList = await _getPhoneticDoneListUseCase.run();
      List<bool> isDoneVowelList = [];
      for (int i = 0; i < state.vowels.length; i++) {
        if (phoneticDoneList.contains(state.vowels[i].phoneticID)) {
          isDoneVowelList.add(true);
        } else {
          isDoneVowelList.add(false);
        }
      }
      List<bool> isDoneConsonantList = [];
      for (int i = 0; i < state.consonants.length; i++) {
        if (phoneticDoneList.contains(state.consonants[i].phoneticID)) {
          isDoneConsonantList.add(true);
        } else {
          isDoneConsonantList.add(false);
        }
      }
      state = state.copyWith(
        progressLoadingStatus: LoadingStatus.success,
        isDoneVowelList: isDoneVowelList,
        isDoneConsonantList: isDoneConsonantList,
      );
    } catch (e) {
      state = state.copyWith(progressLoadingStatus: LoadingStatus.error);
    }
  }
}
