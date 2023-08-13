import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';

class IdiomLearningViewModel extends StateNotifier<IdiomLearningState> {
  final PlayAudioFromUrlUseCase _playAudioFromUrlUseCase;

  IdiomLearningViewModel(
    this._playAudioFromUrlUseCase,
  ) : super(IdiomLearningState(
          idiom: Idiom.initial(),
        ));

  Future<void> setIdiom(Idiom idiom) async {
    state = state.copyWith(idiom: idiom);
  }

  Future<void> playAudio(String endpoint) async {
    String url = idiomAudioURL + endpoint + audioExtension;
    await _playAudioFromUrlUseCase.run(url);
  }
}
