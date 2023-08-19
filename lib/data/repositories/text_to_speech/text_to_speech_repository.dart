import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechRepository {
  final FlutterTts _flutterTts;

  TextToSpeechRepository(this._flutterTts);

  Future<void> speakFromText(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.3);
    await _flutterTts.speak(text);
  }
}
