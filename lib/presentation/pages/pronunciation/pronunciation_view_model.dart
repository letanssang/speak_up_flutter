import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_phonetic_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_word_list_by_phonetic_id_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/ipa/ipa_view.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assesment_status.dart';

class PronunciationViewModel extends StateNotifier<PronunciationState> {
  final GetWordListByPhoneticIDUSeCase getWordListByPhoneticIDUSeCase;
  final SpeakFromTextUseCase speakFromTextUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final PlayCongratsAudioUseCase _playCongratsAudioUseCase;
  final PlayCompleteAudioUseCase _playCompleteAudioUseCase;
  final UpdatePhoneticProgressUseCase _updatePhoneticProgressUseCase;
  final GetPronunciationAssessmentUseCase _getPronunciationAssessmentUseCase;
  final StateNotifierProviderRef ref;

  PronunciationViewModel(
    this.getWordListByPhoneticIDUSeCase,
    this.speakFromTextUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._playAudioFromFileUseCase,
    this._playCongratsAudioUseCase,
    this._playCompleteAudioUseCase,
    this._updatePhoneticProgressUseCase,
    this._getPronunciationAssessmentUseCase,
    this.ref,
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

  void updateCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void resetStateWhenOnNextButtonTap() {
    state = state.copyWith(
      pronunciationAssessmentStatus: PronunciationAssessmentStatus.initial,
      speechSentence: null,
      recordPath: null,
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
        pronunciationAssessmentStatus: PronunciationAssessmentStatus.recording);
    try {
      await _startRecordingUseCase.run();
      // auto stop recording after 3 seconds if user doesn't stop
      Future.delayed(const Duration(seconds: 3), () async {
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
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void speakCurrentWord() {
    speak(state.wordList[state.currentIndex].word);
  }

  Future<void> playRecord() async {
    if (state.recordPath != null) {
      await _playAudioFromFileUseCase.run(state.recordPath!);
    }
  }

  void playCompleteAudio() {
    _playCompleteAudioUseCase.run();
  }

  Future<void> updatePhoneticProgress(int phoneticID) async {
    try {
      await _updatePhoneticProgressUseCase.run(phoneticID);
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
          state.wordList[state.currentIndex].word, state.recordPath ?? '');
      state = state.copyWith(
        speechSentence: speechSentence,
      );
      if (speechSentence.pronScore >= 80) {
        state = state.copyWith(
            pronunciationAssessmentStatus:
                PronunciationAssessmentStatus.wellDone);
        await _playCongratsAudioUseCase.run();
      } else if (speechSentence.pronScore >= 60) {
        state = state.copyWith(
            pronunciationAssessmentStatus:
                PronunciationAssessmentStatus.tryAgain);
      } else {
        state = state.copyWith(
            pronunciationAssessmentStatus:
                PronunciationAssessmentStatus.failed);
      }
    } catch (e) {
      state = state.copyWith(
          pronunciationAssessmentStatus: PronunciationAssessmentStatus.failed);
    }
  }

  @override
  void dispose() {
    ref.read(ipaViewModelProvider.notifier).fetchPhoneticDoneList();
    super.dispose();
  }
}
