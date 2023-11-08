import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechRepository {
  final FlutterTts _flutterTts;

  TextToSpeechRepository(this._flutterTts);

  Future<void> speakFromText(String text) async {
    double speechRate;
    double pitch;
    if (Platform.isIOS) {
      speechRate = 0.4;
      pitch = 1.2;
    } else {
      speechRate = 0.3;
      pitch = 1.0;
    }
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(speechRate);
    await _flutterTts.speak(text);
  }

  Future<void> pauseSpeaking() async {
    await _flutterTts.pause();
  }

  Future<void> speakFromTextSlowly(String text) async {
    double speechRate;
    double pitch;
    if (Platform.isIOS) {
      speechRate = 0.25;
      pitch = 1.2;
    } else {
      speechRate = 0.15;
      pitch = 1.0;
    }
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(speechRate);
    await _flutterTts.speak(text);
  }
}
