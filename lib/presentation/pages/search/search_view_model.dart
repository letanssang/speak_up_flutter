import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/dictionary/get_word_list_from_search_use_case.dart';
import 'package:speak_up/presentation/pages/search/search_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class SearchViewModel extends StateNotifier<SearchState> {
  final GetWordListFromSearchUseCase _getWordListFromSearchUseCase;

  SearchViewModel(
    this._getWordListFromSearchUseCase,
  ) : super(const SearchState());

  Future<void> fetchSuggestionList(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        suggestionList: [],
      );
      return;
    }
    try {
      final wordList = await _getWordListFromSearchUseCase.run(query.trim());
      state = state.copyWith(
        suggestionList: wordList ?? [],
        loadingStatus: LoadingStatus.success,
      );
    } on DioException catch (e) {
      print(e);
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        suggestionList: [],
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
        suggestionList: [],
      );
    }
  }

  void onLoading() {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );
  }
}
