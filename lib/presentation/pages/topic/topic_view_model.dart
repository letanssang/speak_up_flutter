import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class TopicViewModel extends StateNotifier<TopicState> {
  final GetSentenceListFromTopicUseCase getSentenceListFromTopicUseCase;
  final AudioPlayer audioPlayer = AudioPlayer();

  TopicViewModel(
    this.getSentenceListFromTopicUseCase,
  ) : super(const TopicState());

  void init() {
    //audio player listener
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (!mounted) return;
      state = state.copyWith(playerState: event);
    });
  }

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
      final List<GlobalKey> keys = List.generate(
          sentences.length, (index) => GlobalKey(),
          growable: false);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        sentences: sentences,
        isExpandedTranslations: isExpandedTranslations,
        keys: keys,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<void> playCurrentSentence() async {
    final endpoint = state.sentences[state.currentPlayingIndex].audioEndpoint;
    String url = dailyConversationURL + endpoint + audioExtension;
    await audioPlayer.play(UrlSource(url));
  }

  void updateCurrentPlayingIndex(int index) {
    state = state.copyWith(currentPlayingIndex: index);
  }

  void onTapPlayButton() {
    if (state.isPlayingPlaylist) {
      audioPlayer.pause();
      state = state.copyWith(isPlayingPlaylist: false);
    } else {
      playCurrentSentence();
      state = state.copyWith(isPlayingPlaylist: true);
    }
  }

  void onTapMessage(int index) {
    updateCurrentPlayingIndex(index);
    playCurrentSentence();
    state = state.copyWith(isPlayingPlaylist: true);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
