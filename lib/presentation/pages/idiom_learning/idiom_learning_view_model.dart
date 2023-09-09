import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_slow_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/get_sentence_list_from_idiom_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/update_idiom_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/resources/app_audios.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IdiomLearningViewModel extends StateNotifier<IdiomLearningState> {
  final GetSentenceListFromIdiomUseCase _getSentenceListFromIdiomUseCase;
  final PlayAudioFromUrlUseCase _playAudioFromUrlUseCase;
  final PlaySlowAudioFromUrlUseCase _playSlowAudioFromUrlUseCase;
  final PlayAudioFromAssetUseCase _playAudioFromAssetUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final GetTextFromSpeechUseCase _getTextFromSpeechUseCase;
  final SpeakFromTextUseCase _speakingFromTextUseCase;
  final UpdateIdiomProgressUseCase _updateIdiomProgressUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  IdiomLearningViewModel(
    this._getSentenceListFromIdiomUseCase,
    this._playAudioFromUrlUseCase,
    this._playSlowAudioFromUrlUseCase,
    this._playAudioFromAssetUseCase,
    this._playAudioFromFileUseCase,
    this._stopAudioUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._getTextFromSpeechUseCase,
    this._speakingFromTextUseCase,
    this._updateIdiomProgressUseCase,
    this._getCurrentUserUseCase,
  ) : super(IdiomLearningState(
          idiom: Idiom.initial(),
        ));

  Future<void> fetchExampleSentences() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      List<Sentence> sentences =
          await _getSentenceListFromIdiomUseCase.run(state.idiom.idiomID);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        exampleSentences: sentences,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> setIdiom(Idiom idiom) async {
    state = state.copyWith(idiom: idiom);
  }

  Future<void> playAudio(String endpoint) async {
    String url = idiomAudioURL + endpoint + audioExtension;
    await _playAudioFromUrlUseCase.run(url);
  }

  Future<void> playSlowAudio(String endpoint) async {
    String url = idiomAudioURL + endpoint + audioExtension;
    await _playSlowAudioFromUrlUseCase.run(url);
  }

  Future<void> stopAudio() async {
    await _stopAudioUseCase.run();
  }

  Future<void> updateCurrentPage(int page) async {
    state = state.copyWith(currentPage: page);
  }

  Future<void> updateTotalPage() async {
    state = state.copyWith(totalPage: state.exampleSentences.length + 1);
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

  Future<void> playRecord(String? path) async {
    if (path != null) {
      await _playAudioFromFileUseCase.run(path);
    }
  }

  Future<String> getTextFromSpeech() async {
    if (state.recordPath == null) return 'record path is null';
    try {
      final text = await _getTextFromSpeechUseCase.run(state.recordPath!);
      debugPrint('text: $text');
      return text;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  Future<void> speakFromText(String text) async {
    await _speakingFromTextUseCase.run(text);
  }

  Future<void> updateIdiomProgress(int process) async {
    final uid = _getCurrentUserUseCase.run().uid;
    LectureProcess lectureProcess = LectureProcess(
      lectureID: state.idiom.idiomTypeId,
      progress: process + 1,
      uid: uid,
    );
    await _updateIdiomProgressUseCase.run(lectureProcess);
  }
}
