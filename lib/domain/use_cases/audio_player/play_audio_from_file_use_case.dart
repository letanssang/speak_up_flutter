import 'package:speak_up/data/repositories/audio_player/audio_player_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class PlayAudioFromFileUseCase implements FutureUseCase<String, void> {
  @override
  Future<void> run(String input) {
    return injector.get<AudioPlayerRepository>().playAudioFromFile(input);
  }
}
