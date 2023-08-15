import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_idiom_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/resources/app_audios.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class IdiomLearningViewModel extends StateNotifier<IdiomLearningState> {
  final GetSentenceListFromIdiomUseCase _getSentenceListFromIdiomUseCase;
  final PlayAudioFromUrlUseCase _playAudioFromUrlUseCase;
  final PlayAudioFromAssetUseCase _playAudioFromAssetUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;
  final StopAudioUseCase _stopAudioUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final GetTextFromSpeechUseCase _getTextFromSpeechUseCase;

  IdiomLearningViewModel(
    this._getSentenceListFromIdiomUseCase,
    this._playAudioFromUrlUseCase,
    this._playAudioFromAssetUseCase,
    this._playAudioFromFileUseCase,
    this._stopAudioUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._getTextFromSpeechUseCase,
  ) : super(IdiomLearningState(
          idiom: Idiom.initial(),
        ));

  Future<void> fetchExampleSentences() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
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

  Future<String?> onStopRecording() async {
    //when not recording, do nothing
    if (state.recordButtonState == ButtonState.normal) return null;
    state = state.copyWith(recordButtonState: ButtonState.normal);
    try {
      return _stopRecordingUseCase.run();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> correctAnswer() async {
    _playAudioFromAssetUseCase.run(AppAudios.congrats);
  }

  Future<void> playRecord(String? path) async {
    if (path != null) {
      await _playAudioFromFileUseCase.run(path);
    }
  }

  Future<String> getTextFromSpeech(String audioPath) async {
    try {
      final text = await _getTextFromSpeechUseCase.run(audioPath);
      debugPrint('text: $text');
      return text;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
