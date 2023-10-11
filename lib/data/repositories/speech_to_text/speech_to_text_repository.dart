import 'dart:typed_data';

import 'package:speak_up/data/remote/azure_speech_client/azure_speech_client.dart';
import 'package:speak_up/domain/entities/speech_sentence/speech_sentence.dart';

class SpeechToTextRepository {
  final AzureSpeechClient _azureSpeechClient;

  SpeechToTextRepository(this._azureSpeechClient);

  Future<SpeechSentence> getPronunciationAssessment(
    String pronunciationAssessment,
    Uint8List body,
  ) async {
    final response = await _azureSpeechClient.getPronunciationAssessment(
      pronunciationAssessment,
      body,
    );
    return response.nBest.first;
  }
}
