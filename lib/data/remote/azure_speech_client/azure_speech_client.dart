import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:speak_up/data/models/azure_speech_response/azure_speech_response.dart';

part 'azure_speech_client.g.dart';

@RestApi(
    baseUrl:
        'https://southeastasia.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1/')
abstract class AzureSpeechClient {
  factory AzureSpeechClient(Dio dio, {String baseUrl}) = _AzureSpeechClient;

  @POST('')
  Future<AzureSpeechResponse> getPronunciationAssessment(
    @Header('Pronunciation-Assessment') String pronunciationAssessment,
    @Body() Uint8List body,
  );
}
