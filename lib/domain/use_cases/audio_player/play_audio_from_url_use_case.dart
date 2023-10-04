import 'package:speak_up/data/repositories/audio_player/audio_player_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class PlayAudioFromUrlUseCase implements FutureUseCase<String, void> {
  PlayAudioFromUrlUseCase();

  @override
  Future<void> run(String input) async {
    await injector.get<AudioPlayerRepository>().playAudioFromUrl(input);
  }
}
