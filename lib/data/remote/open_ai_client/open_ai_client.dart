import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:speak_up/data/models/open_ai/open_ai_message_response.dart';

part 'open_ai_client.g.dart';

@RestApi(baseUrl: 'https://api.openai.com/v1/chat/completions')
abstract class OpenAIClient {
  factory OpenAIClient(Dio dio, {String baseUrl}) = _OpenAIClient;

  @POST('')
  Future<OpenAIMessageResponse> getMessage(
    @Body() Map<String, dynamic> body,
  );
}
