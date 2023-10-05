import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/presentation/pages/expression/expression_state.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ExpressionViewModel extends StateNotifier<ExpressionState> {
  ExpressionViewModel(
    this._getSentenceListByParentIDUseCase,
    this._playAudioFromUrlUseCase,
  ) : super(const ExpressionState());

  final GetSentenceListByParentIDUseCase _getSentenceListByParentIDUseCase;
  final PlayAudioFromUrlUseCase _playAudioFromUrlUseCase;

  Future<void> fetchSentences(int expressionID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final sentences = await _getSentenceListByParentIDUseCase.run(
          expressionID, LessonEnum.expression);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        sentences: sentences,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  void playAudio(String endpoint) {
    String url = expressionAudioURL + endpoint + audioExtension;
    _playAudioFromUrlUseCase.run(url);
  }
}
