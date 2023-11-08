import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/presentation/pages/pronunciation_topic/pronunciation_topic_state.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';

class PronunciationTopicViewModel
    extends StateNotifier<PronunciationTopicState> {
  PronunciationTopicViewModel(
    this._stopAudioUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._playAudioFromFileUseCase,
    this._getPronunciationAssessmentUseCase,
    this._playCongratsAudioUseCase,
    this._playCompleteAudioUseCase,
  ) : super(const PronunciationTopicState());
  final StopAudioUseCase _stopAudioUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final GetPronunciationAssessmentUseCase _getPronunciationAssessmentUseCase;
  final PlayCongratsAudioUseCase _playCongratsAudioUseCase;
  final PlayCompleteAudioUseCase _playCompleteAudioUseCase;
  Timer? timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int get currentIndex => state.currentIndex;

  void updateSentenceList(List<Sentence> sentences) {
    state = state.copyWith(sentences: sentences);
  }

  void onNextButtonTap() {
    timer?.cancel();
    state = state.copyWith(
      pronunciationAssessmentStatus: PronunciationAssessmentStatus.initial,
      speechSentence: null,
      recordPath: null,
      isStoppedRecording: false,
      isTranslatedAnswer: false,
      currentIndex: state.currentIndex + 1,
    );
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

  Future<void> playRecord() async {
    if (state.recordPath != null) {
      await _playAudioFromFileUseCase.run(state.recordPath!);
    }
  }

  Future<void> onStartRecording() async {
    state = state.copyWith(
      pronunciationAssessmentStatus: PronunciationAssessmentStatus.recording,
      isStoppedRecording: false,
    );
    try {
      _audioPlayer.stop();
      await _startRecordingUseCase.run();
      final seconds =
          countWordInSentence(state.sentences[state.currentIndex * 2 + 1].text);
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

  Future<void> getPronunciationAssessment() async {
    state = state.copyWith(
        pronunciationAssessmentStatus:
            PronunciationAssessmentStatus.inProgress);
    try {
      final speechSentence = await _getPronunciationAssessmentUseCase.run(
          state.sentences[state.currentIndex * 2 + 1].text,
          state.recordPath ?? '');
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

  void playCompleteAudio() {
    _playCompleteAudioUseCase.run();
  }

  void speakCurrentQuestion() {
    final endpoint = state.sentences[state.currentIndex * 2].audioEndpoint;
    String url = dailyConversationURL + endpoint + audioExtension;
    _audioPlayer.play(UrlSource(url));
  }

  Future<void> speakCurrentAnswer() async {
    final endpoint = state.sentences[state.currentIndex * 2 + 1].audioEndpoint;
    String url = dailyConversationURL + endpoint + audioExtension;
    await _audioPlayer.play(UrlSource(url));
  }

  void onTranslateButtonTap() {
    state = state.copyWith(isTranslatedAnswer: !state.isTranslatedAnswer);
  }

  @override
  void dispose() {
    _stopAudioUseCase.run();
    timer?.cancel();
    super.dispose();
  }
}
