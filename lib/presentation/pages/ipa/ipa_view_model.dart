import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phonetic_list_use_case.dart';
import 'package:speak_up/presentation/pages/ipa/ipa_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IpaViewModel extends StateNotifier<IpaState> {
  final GetPhoneticListUseCase _getPhoneticListUseCase;

  IpaViewModel(this._getPhoneticListUseCase) : super(const IpaState());

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
}
