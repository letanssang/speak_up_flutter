import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_pattern_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_pattern_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/pattern_learning/pattern_learning_state.dart';
import 'package:speak_up/presentation/resources/app_audios.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PatternLearningViewModel extends StateNotifier<PatternLearningState> {
  PatternLearningViewModel(
    this._getSentenceListFromPatternUseCase,
    this._stopAudioUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._playAudioFromAssetUseCase,
    this._playAudioFromFileUseCase,
    this._getTextFromSpeechUseCase,
    this._speakingFromTextUseCase,
    this._updatePatternProgressUseCase,
    this._getCurrentUserUseCase,
  ) : super(const PatternLearningState());

  final GetSentenceListFromPatternUseCase _getSentenceListFromPatternUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final PlayAudioFromAssetUseCase _playAudioFromAssetUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final GetTextFromSpeechUseCase _getTextFromSpeechUseCase;
  final SpeakFromTextUseCase _speakingFromTextUseCase;
  final UpdatePatternProgressUseCase _updatePatternProgressUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  bool get isAnimating => state.isAnimating;
  bool get isLastPage => state.currentPage >= state.totalPage;

  Future<void> fetchExampleSentences(SentencePattern pattern) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      List<Sentence> sentences =
          await _getSentenceListFromPatternUseCase.run(pattern.patternID);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        exampleSentences: sentences,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> stopAudio() async {
    await _stopAudioUseCase.run();
  }

  void updateCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void updateTotalPage() {
    state = state.copyWith(totalPage: state.exampleSentences.length);
  }

  Future<void> onStartRecording() async {
    state = state.copyWith(recordButtonState: ButtonState.loading);
    try {
      await _startRecordingUseCase.run();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onStopRecording() async {
    //when not recording, do nothing
    if (state.recordButtonState == ButtonState.normal) return;
    state = state.copyWith(recordButtonState: ButtonState.normal);
    try {
      final recordPath = await _stopRecordingUseCase.run();
      state = state.copyWith(recordPath: recordPath);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> correctAnswer() async {
    _playAudioFromAssetUseCase.run(AppAudios.congrats);
  }

  Future<void> playRecord() async {
    if (state.recordPath != null) {
      await _playAudioFromFileUseCase.run(state.recordPath!);
    }
  }

  Future<String> getTextFromSpeech() async {
    if (state.recordPath == null) return 'record path is null';
    try {
      final text = await _getTextFromSpeechUseCase.run(state.recordPath!);
      return text;
    } catch (e) {
      return '';
    }
  }

  Future<void> speakFromText(String text) async {
    await _speakingFromTextUseCase.run(text);
  }

  void updateAnimatingState(bool isAnimating) {
    state = state.copyWith(isAnimating: isAnimating);
  }

  Future<void> updatePatternProgress(int patternId) async {
    final uid = _getCurrentUserUseCase.run().uid;
    final lectureProcess =
        LectureProcess(lectureID: patternId, progress: 0, uid: uid);
    await _updatePatternProgressUseCase.run(lectureProcess);
  }
}
