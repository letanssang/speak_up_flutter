import 'package:speak_up/data/repositories/open_ai/open_ai_repository.dart';
import 'package:speak_up/domain/entities/message/message.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetMessageResponseFromOpenAIUseCase
    implements FutureUseCase<List<Map<String, String>>, Message> {
  @override
  Future<Message> run(List<Map<String, String>> input) {
    return injector<OpenAIRepository>().getMessage(input);
  }
}
