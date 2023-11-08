import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_slowly_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/expression_type/expression_type_view.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_view.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_view.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_view.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_state.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';

class PronunciationPracticeViewModel
    extends StateNotifier<PronunciationPracticeState> {
  final GetSentenceListByParentIDUseCase _getSentenceListByParentIDUseCase;
  final SpeakFromTextUseCase speakFromTextUseCase;
  final SpeakFromTextSlowlyUseCase speakFromTextSlowlyUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final PlayCongratsAudioUseCase _playCongratsAudioUseCase;
  final PlayCompleteAudioUseCase _playCompleteAudioUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final GetPronunciationAssessmentUseCase _getPronunciationAssessmentUseCase;
  final UpdateProgressUseCase _updateProgressUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StateNotifierProviderRef ref;
  Timer? timer;

  PronunciationPracticeViewModel(
    this._getSentenceListByParentIDUseCase,
    this.speakFromTextUseCase,
    this.speakFromTextSlowlyUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._playAudioFromFileUseCase,
    this._playCongratsAudioUseCase,
    this._playCompleteAudioUseCase,
    this._stopAudioUseCase,
    this._getPronunciationAssessmentUseCase,
    this._updateProgressUseCase,
    this._getCurrentUserUseCase,
    this.ref,
  ) : super(const PronunciationPracticeState());

  Future<void> fetchSentenceList(int parentID, LessonEnum lessonEnum,
      {Sentence? sentence}) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      if (lessonEnum == LessonEnum.topic) {
        state = state.copyWith(
          sentences: [sentence!],
          loadingStatus: LoadingStatus.success,
        );
        return;
      }
      final sentences =
          await _getSentenceListByParentIDUseCase.run(parentID, lessonEnum);
      state = state.copyWith(
        sentences: sentences,
        loadingStatus: LoadingStatus.success,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  void updateCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void resetStateWhenOnNextButtonTap() {
    timer?.cancel();
    state = state.copyWith(
      pronunciationAssessmentStatus: PronunciationAssessmentStatus.initial,
      speechSentence: null,
      recordPath: null,
      isStoppedRecording: false,
    );
  }

  Future<void> speak(String text) async {
    await speakFromTextUseCase.run(text);
  }

  Future<void> speakSlowly(String text) async {
    await speakFromTextSlowlyUseCase.run(text);
  }

  Future<void> onRecordButtonTap() async {
    if (state.pronunciationAssessmentStatus ==
        PronunciationAssessmentStatus.recording) {
      await onStopRecording();
      await getPronunciationAssessment();
    } else {
      await onStartRecording();
    }
  }

  Future<void> onStartRecording() async {
    state = state.copyWith(
      pronunciationAssessmentStatus: PronunciationAssessmentStatus.recording,
      isStoppedRecording: false,
    );
    try {
      _stopAudioUseCase.run();
      await _startRecordingUseCase.run();
      final seconds =
          countWordInSentence(state.sentences[state.currentIndex].text);
      timer = Timer(Duration(seconds: seconds), () {
        if (state.pronunciationAssessmentStatus ==
            PronunciationAssessmentStatus.recording) {
          onRecordButtonTap();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onStopRecording() async {
    //when not recording, do nothing
    if (state.pronunciationAssessmentStatus !=
        PronunciationAssessmentStatus.recording) return;
    try {
      timer?.cancel();
      final recordPath = await _stopRecordingUseCase.run();
      state = state.copyWith(
        recordPath: recordPath,
        isStoppedRecording: true,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void speakCurrentSentence() {
    speak(state.sentences[state.currentIndex].text);
  }

  Future<void> playRecord() async {
    if (state.recordPath != null) {
      await _playAudioFromFileUseCase.run(state.recordPath!);
    }
  }

  void playCompleteAudio() {
    _playCompleteAudioUseCase.run();
  }

  Future<void> updateProgress(int id, LessonEnum lessonEnum,
      {int? progress}) async {
    int newProgress = 0;
    if (progress != null) {
      newProgress = progress + 1;
    }
    ;
    final process = LectureProcess(
        lectureID: id,
        uid: _getCurrentUserUseCase.run().uid,
        progress: newProgress);
    try {
      await _updateProgressUseCase.run(process, lessonEnum);
      switch (lessonEnum) {
        case LessonEnum.pattern:
          await ref
              .read(patternLessonDetailViewModelProvider.notifier)
              .fetchPatternDoneList();
          break;
        case LessonEnum.expression:
          await ref
              .read(expressionTypeViewModelProvider.notifier)
              .fetchExpressionDoneList();
        // break;
        case LessonEnum.phrasalVerb:
          await ref
              .read(phrasalVerbViewModelProvider.notifier)
              .updateProgressState(id);
          break;
        case LessonEnum.idiom:
          await ref
              .read(idiomViewModelProvider.notifier)
              .updateProgressState(id);
        default:
          return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getPronunciationAssessment() async {
    state = state.copyWith(
        pronunciationAssessmentStatus:
            PronunciationAssessmentStatus.inProgress);
    try {
      final speechSentence = await _getPronunciationAssessmentUseCase.run(
          state.sentences[state.currentIndex].text, state.recordPath ?? '');
      state = state.copyWith(
        speechSentence: speechSentence,
      );
      final PronunciationAssessmentStatus status =
          getPronunciationAssessmentStatus(speechSentence.pronScore);
      if (status == PronunciationAssessmentStatus.wellDone) {
        _playCongratsAudioUseCase.run();
      }
      state = state.copyWith(pronunciationAssessmentStatus: status);
    } catch (e) {
      state = state.copyWith(
          pronunciationAssessmentStatus: PronunciationAssessmentStatus.failed);
    }
  }

  @override
  void dispose() {
    _stopAudioUseCase.run();
    timer?.cancel();
    super.dispose();
  }
}
