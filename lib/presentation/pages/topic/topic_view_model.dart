import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/pause_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class TopicViewModel extends StateNotifier<TopicState> {
  final GetSentenceListFromTopicUseCase getSentenceListFromTopicUseCase;
  final PlayAudioFromUrlUseCase playAudioFromUrlUseCase;
  final PauseAudioUseCase pauseAudioUseCase;
  final AudioPlayer audioPlayer;

  TopicViewModel(
    this.getSentenceListFromTopicUseCase,
    this.playAudioFromUrlUseCase,
    this.pauseAudioUseCase,
    this.audioPlayer,
  ) : super(const TopicState());

  void onTapExpandedTranslation(int index) {
    List<bool> isExpandedTranslations = List.from(state.isExpandedTranslations);
    isExpandedTranslations[index] = !isExpandedTranslations[index];
    state = state.copyWith(isExpandedTranslations: isExpandedTranslations);
  }

  Future<void> fetchSentenceList(int topicID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final sentences = await getSentenceListFromTopicUseCase.run(topicID);
      final List<bool> isExpandedTranslations =
          List.generate(sentences.length, (index) => false, growable: false);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        sentences: sentences,
        isExpandedTranslations: isExpandedTranslations,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> onTapSpeaker(String endpoint) async {
    String url = dailyConversationURL + endpoint + audioExtension;
    await playAudioFromUrlUseCase.run(url);
  }
}
