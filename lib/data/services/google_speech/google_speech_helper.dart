import 'package:google_speech/google_speech.dart';

final config = RecognitionConfig(
    encoding: AudioEncoding.LINEAR16,
    model: RecognitionModel.basic,
    enableAutomaticPunctuation: true,
    sampleRateHertz: 44100,
    languageCode: 'en-US');

const String googleSpeechAssetKeyPath =
    'assets/keys/google_cloud_speech_to_text_key.json';
