import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/pages/topic/topic_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final topicViewModelProvider =
    StateNotifierProvider.autoDispose<TopicViewModel, TopicState>(
  (ref) => TopicViewModel(
    injector.get<GetSentenceListFromTopicUseCase>(),
  ),
);

class TopicView extends ConsumerStatefulWidget {
  const TopicView({super.key});

  @override
  ConsumerState<TopicView> createState() => _TopicViewState();
}

class _TopicViewState extends ConsumerState<TopicView> {
  Topic? topic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    topic = ModalRoute.of(context)!.settings.arguments as Topic;
    await ref
        .read(topicViewModelProvider.notifier)
        .fetchSentenceList(topic!.topicID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topicViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: topic != null ? Text(topic!.topicName) : null,
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildBodySuccess(state.sentences)
          : state.loadingStatus == LoadingStatus.error
              ? buildBodyError()
              : buildBodyInProgress(),
    );
  }

  Widget buildBodySuccess(List<Sentence> sentences) {
    return ListView.builder(
      itemCount: sentences.length,
      itemBuilder: (context, index) {
        final sentence = sentences[index];
        return ListTile(
          title: Text(sentence.text),
        );
      },
    );
  }

  Widget buildBodyInProgress() {
    return const Center(
      child: AppLoadingIndicator(),
    );
  }

  Widget buildBodyError() {
    return const Center(
      child: Text('Something went wrong!'),
    );
  }
}
