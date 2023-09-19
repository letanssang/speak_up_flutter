import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_word_list_by_phonetic_id_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_state.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class PronunciationViewModel extends StateNotifier<PronunciationState> {
  final GetWordListByPhoneticIDUSeCase getWordListByPhoneticIDUSeCase;
  final SpeakFromTextUseCase speakFromTextUseCase;
  final StartRecordingUseCase _startRecordingUseCase;
  final StopRecordingUseCase _stopRecordingUseCase;
  final GetTextFromSpeechUseCase _getTextFromSpeechUseCase;
  final PlayAudioFromFileUseCase _playAudioFromFileUseCase;

  PronunciationViewModel(
    this.getWordListByPhoneticIDUSeCase,
    this.speakFromTextUseCase,
    this._startRecordingUseCase,
    this._stopRecordingUseCase,
    this._getTextFromSpeechUseCase,
    this._playAudioFromFileUseCase,
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

  Future<void> speak(String text) async {
    await speakFromTextUseCase.run(text);
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

  Future<void> playRecord() async {
    if (state.recordPath != null) {
      await _playAudioFromFileUseCase.run(state.recordPath!);
    }
  }
}
