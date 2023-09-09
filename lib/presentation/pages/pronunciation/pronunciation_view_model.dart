import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_word_list_by_phonetic_id_use_case.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PronunciationViewModel extends StateNotifier<PronunciationState> {
  GetWordListByPhoneticIDUSeCase getWordListByPhoneticIDUSeCase;
  PronunciationViewModel(
    this.getWordListByPhoneticIDUSeCase,
  ) : super(const PronunciationState());
  Future<void> fetchWordList(int phoneticID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final wordList = await getWordListByPhoneticIDUSeCase.run(phoneticID);
      state = state.copyWith(
        wordList: wordList,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
