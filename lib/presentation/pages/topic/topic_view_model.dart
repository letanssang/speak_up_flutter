import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class TopicViewModel extends StateNotifier<TopicState> {
  final GetSentenceListFromTopicUseCase getSentenceListFromTopicUseCase;

  TopicViewModel(
    this.getSentenceListFromTopicUseCase,
  ) : super(const TopicState());

  Future<void> fetchSentenceList(int topicID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    try {
      final sentences = await getSentenceListFromTopicUseCase.run(topicID);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        sentences: sentences,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
