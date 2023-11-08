import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class TopicViewModel extends StateNotifier<TopicState> {
  final GetSentenceListByParentIDUseCase _getSentenceListByParentIDUseCase;
  final AudioPlayer _audioPlayer = AudioPlayer();

  TopicViewModel(
    this._getSentenceListByParentIDUseCase,
  ) : super(const TopicState());

  void init() {
    //audio player listener
    _audioPlayer.onPlayerStateChanged.listen((event) {
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
      final sentences = await _getSentenceListByParentIDUseCase.run(
          topicID, LessonEnum.topic);
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
    await _audioPlayer.play(UrlSource(url));
  }

  void updateCurrentPlayingIndex(int index) {
    state = state.copyWith(currentPlayingIndex: index);
  }

  void onTapPlayButton() {
    if (state.isPlayingPlaylist) {
      onPauseDialog();
    } else {
      playCurrentSentence();
      state = state.copyWith(isPlayingPlaylist: true);
    }
  }

  void onPauseDialog() {
    _audioPlayer.pause();
    state = state.copyWith(isPlayingPlaylist: false);
  }

  void onTapMessage(int index) {
    updateCurrentPlayingIndex(index);
    playCurrentSentence();
    state = state.copyWith(isPlayingPlaylist: true);
  }

  void onTapRepeatButton() {
    state = state.copyWith(isRepeated: !state.isRepeated);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
