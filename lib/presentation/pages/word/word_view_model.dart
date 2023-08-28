import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/dictionary/get_word_detail_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/word/word_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class WordViewModel extends StateNotifier<WordState> {
  final GetWordDetailUseCase _getDetailWordUseCase;
  final SpeakFromTextUseCase _speakFromTextUseCase;

  WordViewModel(
    this._getDetailWordUseCase,
    this._speakFromTextUseCase,
  ) : super(const WordState());

  Future<void> fetchWordDetail(String word) async {
    try {
      state = state.copyWith(
        loadingStatus: LoadingStatus.loading,
      );
      final wordDetail = await _getDetailWordUseCase.run(word);
      state = state.copyWith(
        detailWord: wordDetail,
        isExpandedList: List.generate(
          wordDetail.results!.length,
          (index) => false,
        ),
        loadingStatus: LoadingStatus.success,
      );
    } on DioException {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
      );
    }
  }

  Future<void> speakFromText(String text) async {
    await _speakFromTextUseCase.run(text);
  }

  void changeExpandedList(int index, bool isExpanded) {
    final isExpandedList = state.isExpandedList.toList();
    isExpandedList[index] = !isExpandedList[index];
    state = state.copyWith(
      isExpandedList: isExpandedList,
    );
  }
}
