import 'package:speak_up/data/repositories/audio_player/audio_player_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class PauseAudioUseCase implements FutureOutputUseCase<void> {
  @override
  Future<void> run() {
    return injector.get<AudioPlayerRepository>().pauseAudio();
  }
}
