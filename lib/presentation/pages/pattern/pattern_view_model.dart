import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_state.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PatternViewModel extends StateNotifier<PatternState> {
  PatternViewModel(
    this._getSentenceListByParentID,
    this._speakFromTextUseCase,
  ) : super(const PatternState());

  final GetSentenceListByParentIDUseCase _getSentenceListByParentID;
  final SpeakFromTextUseCase _speakFromTextUseCase;

  Future<void> fetchExampleList(int patternId) async {
    state = state.copyWith(
      loadingStatus: LoadingStatus.loading,
    );
    try {
      final sentenceExamples =
          await _getSentenceListByParentID.run(patternId, LessonEnum.pattern);
      state = state.copyWith(
        sentenceExamples: sentenceExamples,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        loadingStatus: LoadingStatus.error,
      );
    }
  }

  void toggleTranslate() {
    state = state.copyWith(
      isTranslated: !state.isTranslated,
    );
  }

  void toggleDialog() {
    state = state.copyWith(
      isOpenedDialog: !state.isOpenedDialog,
    );
  }

  void speak(String text) {
    _speakFromTextUseCase.run(text);
  }
}
