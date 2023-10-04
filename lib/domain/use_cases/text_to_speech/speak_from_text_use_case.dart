import 'package:speak_up/data/repositories/text_to_speech/text_to_speech_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class SpeakFromTextUseCase implements FutureUseCase<String, void> {
  @override
  Future<void> run(String input) async {
    return await injector.get<TextToSpeechRepository>().speakFromText(input);
  }
}
