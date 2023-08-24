import 'dart:io';

import 'package:google_speech/google_speech.dart';

AudioEncoding getAudioEncoding() {
  if (Platform.isIOS) {
    return AudioEncoding.FLAC;
  } else if (Platform.isAndroid) {
    return AudioEncoding.LINEAR16;
  } else {
    return AudioEncoding.LINEAR16;
  }
}

final config = RecognitionConfig(
    encoding: getAudioEncoding(),
    model: RecognitionModel.basic,
    enableAutomaticPunctuation: true,
    sampleRateHertz: 44000,
    languageCode: 'en-US');

const String googleSpeechAssetKeyPath =
    'assets/keys/google_cloud_speech_to_text_key.json';
