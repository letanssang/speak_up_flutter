import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_state.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';

class PronunciationPracticeViewModel
    extends StateNotifier<PronunciationPracticeState> {
  final GetSentenceListByParentIDUseCase _getSentenceListByParentIDUseCase;
  final SpeakFromTextUseCase speakFromTextUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final PlayCongratsAudioUseCase _playCongratsAudioUseCase;
  final PlayCompleteAudioUseCase _playCompleteAudioUseCase;
  final GetPronunciationAssessmentUseCase _getPronunciationAssessmentUseCase;
  final StateNotifierProviderRef ref;

  PronunciationPracticeViewModel(
    this._getSentenceListByParentIDUseCase,
    this.speakFromTextUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._playAudioFromFileUseCase,
    this._playCongratsAudioUseCase,
    this._playCompleteAudioUseCase,
    this._getPronunciationAssessmentUseCase,
    this.ref,
  ) : super(const PronunciationPracticeState());

  Future<void> fetchSentenceList(int parentID, LessonEnum lessonEnum) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
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
      await _startRecordingUseCase.run();
      // auto stop recording after 3 seconds if user doesn't stop
      final seconds =
          countWordInSentence(state.sentences[state.currentIndex].text);
      print(seconds);
      //TODO: change seconds number
      Future.delayed(Duration(seconds: seconds), () async {
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

  Future<void> updateProgress(int phoneticID, LessonEnum lessonEnum) async {
    try {
      ///TODO: update progress
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
}
