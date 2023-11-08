import 'package:speak_up/data/repositories/audio_player/audio_player_repository.dart';
import 'package:speak_up/data/repositories/text_to_speech/text_to_speech_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class StopAudioUseCase implements FutureOutputUseCase<void> {
  StopAudioUseCase();

  @override
  Future<void> run() async {
    await injector.get<AudioPlayerRepository>().stopAudio();
    await injector.get<TextToSpeechRepository>().pauseSpeaking();
  }
}
