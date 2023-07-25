import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/pages/topic/topic_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final topicViewModelProvider =
    StateNotifierProvider.autoDispose<TopicViewModel, TopicState>(
  (ref) => TopicViewModel(
    injector.get<GetSentenceListFromTopicUseCase>(),
    injector.get<PlayAudioFromUrlUseCase>(),
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
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: topic != null ? Text(topic!.topicName) : null,
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildBodySuccess(
              state.sentences, isDarkTheme, state.isExpandedTranslations)
          : state.loadingStatus == LoadingStatus.error
              ? buildBodyError()
              : buildBodyInProgress(),
    );
  }

  Widget buildBodySuccess(List<Sentence> sentences, bool isDarkTheme,
      List<bool> isExpandedTranslations) {
    return ListView.builder(
      itemCount: sentences.length,
      itemBuilder: (context, index) {
        final sentence = sentences[index];
        return index % 2 == 0
            ? buildQuestionerMessage(
                isDarkTheme, sentence, isExpandedTranslations[index], () {
                ref
                    .read(topicViewModelProvider.notifier)
                    .onTapSpeaker(sentence.audioEndpoint);
              }, () {
                ref
                    .read(topicViewModelProvider.notifier)
                    .onTapExpandedTranslation(index);
              })
            : buildRespondentMessage(
                context, isDarkTheme, sentence, isExpandedTranslations[index],
                () {
                ref
                    .read(topicViewModelProvider.notifier)
                    .onTapSpeaker(sentence.audioEndpoint);
              }, () {
                ref
                    .read(topicViewModelProvider.notifier)
                    .onTapExpandedTranslation(index);
              });
      },
    );
  }

  Widget buildQuestionerMessage(
      bool isDarkTheme,
      Sentence sentence,
      bool isExpandedTranslation,
      Function()? onTapSpeaker,
      Function()? onTapTranslation) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 48,
              right: 64,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkTheme ? Colors.grey[200] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme
                      ? Colors.black.withOpacity(0.25)
                      : Colors.grey.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sentence.text,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: onTapSpeaker,
                        child: Icon(
                          Icons.volume_up,
                          size: 20,
                          color: isExpandedTranslation
                              ? Colors.grey[800]
                              : Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: onTapTranslation,
                        child: Icon(
                          Icons.translate,
                          size: 20,
                          color: isExpandedTranslation
                              ? Colors.grey[800]
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isExpandedTranslation)
                  Text(
                    sentence.translation,
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.justify,
                  ),
              ],
            ),
          ),
          Positioned(
              left: -5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppImages.questioner(width: ScreenUtil().setWidth(40)),
              ))
        ],
      ),
    );
  }

  Widget buildRespondentMessage(
      BuildContext context,
      bool isDarkTheme,
      Sentence sentence,
      bool isExpandedTranslation,
      Function()? onTapSpeaker,
      Function()? onTapTranslation) {
    return Align(
      alignment: Alignment.centerRight,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 64,
              right: 48,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: isDarkTheme
                      ? Colors.black.withOpacity(0.25)
                      : Colors.grey.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  sentence.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: onTapSpeaker,
                        child: Icon(
                          Icons.volume_up,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: onTapTranslation,
                        child: Icon(
                          Icons.translate,
                          size: 20,
                          color: isExpandedTranslation
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isExpandedTranslation)
                  Text(
                    sentence.translation,
                    style: TextStyle(
                      color: Colors.grey[350],
                    ),
                    textAlign: TextAlign.justify,
                  ),
              ],
            ),
          ),
          Positioned(
            right: -5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppImages.respondent(width: ScreenUtil().setWidth(40)),
            ),
          )
        ],
      ),
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
