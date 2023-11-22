import 'package:speak_up/data/models/open_ai/open_ai_message_response.dart';
import 'package:speak_up/data/repositories/open_ai/open_ai_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetMessageResponseFromOpenAIUseCase
    implements FutureUseCase<List<Map<String, String>>, Message> {
  @override
  Future<Message> run(List<Map<String, String>> input) {
    return injector<OpenAIRepository>().getMessage(input);
  }
}
