import 'dart:io';

import 'package:google_speech/google_speech.dart';
import 'package:speak_up/data/remote/google_speech/google_speech_helper.dart';

class SpeechToTextRepository {
  final SpeechToText _speechToText;

  SpeechToTextRepository(this._speechToText);

  Future<String> getTextFromSpeech(String audioPath) async {
    final audio = await _getAudioContent(audioPath);
    final response = await _speechToText.recognize(config, audio);
    final text =
        response.results.map((e) => e.alternatives.first.transcript).join('\n');
    return text;
  }

  Future<List<int>> _getAudioContent(String audioPath) async {
    return await File(audioPath).readAsBytes();
  }
}
