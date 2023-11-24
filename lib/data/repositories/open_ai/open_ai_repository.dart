import 'package:speak_up/data/remote/open_ai_client/open_ai_client.dart';
import 'package:speak_up/domain/entities/message/message.dart';

class OpenAIRepository {
  final OpenAIClient _openAIClient;

  OpenAIRepository(this._openAIClient);

  //{
  //     "model": "gpt-3.5-turbo",
  //     "messages": [
  //       {
  //         "role": "system",
  //         "content": "You are a very good English teacher"
  //       },
  //       {
  //         "role": "user",
  //         "content": "Hello. Can I talk with you?"
  //       }
  //     ]
  //   }
  Future<Message> getMessage(List<Map<String, String>> messages) async {
    final body = {"model": "gpt-3.5-turbo", "messages": messages};
    final response = await _openAIClient.getMessage(body);
    return Message(
      role: response.choices[0].message.role,
      content: response.choices[0].message.content,
    );
  }
}
