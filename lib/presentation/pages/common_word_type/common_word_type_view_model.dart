import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_common_word_list_by_type.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/common_word_type/common_word_type_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class CommonWordTypeViewModel extends StateNotifier<CommonWordTypeState> {
  CommonWordTypeViewModel(
    this._getCommonWordListByTypeUseCase,
    this._speakFromTextUseCase,
  ) : super(const CommonWordTypeState());
  final GetCommonWordListByTypeUseCase _getCommonWordListByTypeUseCase;
  final SpeakFromTextUseCase _speakFromTextUseCase;

  Future<void> fetchCommonWordList(int type) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final commonWordList = await _getCommonWordListByTypeUseCase.run(type);
      if (!mounted) return;
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        commonWordList: commonWordList,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  void onSearchLoading() {
    state = state.copyWith(
      searchLoadingStatus: LoadingStatus.loading,
    );
  }

  void onSearchInitial() {
    state = state.copyWith(
      searchLoadingStatus: LoadingStatus.initial,
    );
  }

// filter common word list by search value
  Future<void> onSearch(String value) async {
    if (value.isEmpty) {
      state = state.copyWith(
        suggestionList: [],
      );
      return;
    }
    final suggestionList = state.commonWordList
        .where((element) =>
            element.commonWord.toLowerCase().contains(value.toLowerCase()))
        .toList();
    state = state.copyWith(
      suggestionList: suggestionList,
      searchLoadingStatus: LoadingStatus.success,
    );
  }

  void speak(String text) {
    _speakFromTextUseCase.run(text);
  }
}
