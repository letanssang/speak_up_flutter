import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class PlayCongratsAudioUseCase implements FutureOutputUseCase {
  @override
  Future run() {
    return injector.get<PlayAudioFromAssetUseCase>().run('audios/congrats.mp3');
  }
}
