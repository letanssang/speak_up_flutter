import 'package:speak_up/data/repositories/speech_to_text/speech_to_text_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetTextFromSpeechUseCase extends FutureUseCase<String, String> {
  @override
  Future<String> run(String input) {
    return injector.get<SpeechToTextRepository>().getTextFromSpeech(input);
  }
}
