import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/entities/phrasal_verb/phrasal_verb.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_phrasal_verb_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_phrasal_verb_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/phrasal_verb_learning/phrasal_verb_learning_state.dart';
import 'package:speak_up/presentation/resources/app_audios.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PhrasalVerbLearningViewModel
    extends StateNotifier<PhrasalVerbLearningState> {
  PhrasalVerbLearningViewModel(
    this._getSentenceListFromPhrasalVerbUseCase,
    this._playAudioFromAssetUseCase,
    this._playAudioFromFileUseCase,
    this._stopAudioUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._getTextFromSpeechUseCase,
    this._speakingFromTextUseCase,
    this._updatePhrasalVerbProgressUseCase,
    this._getCurrentUserUseCase,
  ) : super(const PhrasalVerbLearningState());
  final GetSentenceListFromPhrasalVerbUseCase
      _getSentenceListFromPhrasalVerbUseCase;
  final PlayAudioFromAssetUseCase _playAudioFromAssetUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final GetTextFromSpeechUseCase _getTextFromSpeechUseCase;
  final SpeakFromTextUseCase _speakingFromTextUseCase;
  final UpdatePhrasalVerbProgressUseCase _updatePhrasalVerbProgressUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> fetchExampleSentences(PhrasalVerb phrasalVerb) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      List<Sentence> sentences = await _getSentenceListFromPhrasalVerbUseCase
          .run(phrasalVerb.phrasalVerbID);
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

  Future<void> updateCurrentPage(int page) async {
    state = state.copyWith(currentPage: page);
  }

  Future<void> updateTotalPage() async {
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

  Future<void> updatePhrasalVerbProgress(
      int process, int phrasalVerbTypeID) async {
    final uid = _getCurrentUserUseCase.run().uid;
    LectureProcess lectureProcess = LectureProcess(
      lectureID: phrasalVerbTypeID,
      progress: process + 1,
      uid: uid,
    );
    await _updatePhrasalVerbProgressUseCase.run(lectureProcess);
  }
}
