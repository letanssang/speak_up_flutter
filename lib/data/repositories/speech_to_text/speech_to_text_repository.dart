import 'dart:io';

import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart';
import 'package:google_speech/google_speech.dart';
import 'package:speak_up/data/services/google_speech/google_speech_helper.dart';

class SpeechToTextRepository {
  final SpeechToText _speechToText;
  SpeechToTextRepository(this._speechToText);

  Future<String> getTextFromSpeech(String audioPath) async {
    final audio = await _getAudioContent(audioPath);
    final response = await _speechToText.recognize(config, audio);
    return convertResponseToString(response);
  }

  Future<List<int>> _getAudioContent(String audioPath) async {
    return File(audioPath).readAsBytesSync().toList();
  }

  String convertResponseToString(RecognizeResponse response) {
    String recognizedText = '';

    for (var result in response.results) {
      recognizedText += '${result.alternatives[0].transcript} ';
    }

    return recognizedText.trim();
  }
}
