import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view.dart';
import 'package:speak_up/presentation/pages/topic/topic_state.dart';
import 'package:speak_up/presentation/pages/topic/topic_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/divider/app_divider.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final topicViewModelProvider =
    StateNotifierProvider.autoDispose<TopicViewModel, TopicState>(
  (ref) => TopicViewModel(
    injector.get<GetSentenceListByParentIDUseCase>(),
  ),
);

class TopicView extends ConsumerStatefulWidget {
  const TopicView({super.key});

  @override
  ConsumerState<TopicView> createState() => _TopicViewState();
}

class _TopicViewState extends ConsumerState<TopicView> {
  Topic topic = Topic.initial();
  final ScrollController _scrollController = ScrollController();

  TopicViewModel get _viewModel => ref.read(topicViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    topic = ModalRoute.of(context)!.settings.arguments as Topic;
    _viewModel.init();
    await _viewModel.fetchSentenceList(topic.topicID);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToCurrentMessage(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final distance = renderBox?.size.height ?? 0;
    // scroll down distance pixels
    // calculate duration based on distance
    _scrollController.animateTo(
      _scrollController.offset + distance,
      duration: Duration(milliseconds: (distance * 1.5).toInt()),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topicViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    ref.listen(topicViewModelProvider.select((value) => value.playerState),
        (previous, next) {
      if (next == PlayerState.completed && state.isPlayingPlaylist) {
        if (state.isRepeated) {
          _viewModel.playCurrentSentence();
        } else if (state.currentPlayingIndex < state.sentences.length - 1) {
          _viewModel.updateCurrentPlayingIndex(state.currentPlayingIndex + 1);
          scrollToCurrentMessage(state.keys[state.currentPlayingIndex]);
          _viewModel.playCurrentSentence();
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
            language == Language.english ? topic.topicName : topic.translation,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
            )),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildBodySuccess(state, isDarkTheme)
          : state.loadingStatus == LoadingStatus.error
              ? const AppErrorView()
              : const AppLoadingIndicator(),
    );
  }

  Widget buildBodySuccess(TopicState state, bool isDarkTheme) {
    return Column(
      children: [
        Flexible(
          flex: 6,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 16.0, left: 16.0, right: 16.0),
                  child: Text(
                    AppLocalizations.of(context)!.listenToTheConversation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return index % 2 == 0
                        ? buildQuestionerMessage(isDarkTheme, state, index)
                        : buildRespondentMessage(isDarkTheme, state, index);
                  },
                  childCount: state.sentences.length,
                ),
              ),
            ],
          ),
        ),
        const AppDivider(),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCustomButton(
              AppLocalizations.of(context)!.repeat,
              onTap: _viewModel.onTapRepeatButton,
              isTurnOn: state.isRepeated,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: ScreenUtil().setHeight(32),
                child: IconButton(
                    onPressed: _viewModel.onTapPlayButton,
                    icon: Icon(
                      state.isPlayingPlaylist ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: ScreenUtil().setHeight(32),
                    )),
              ),
            ),
            buildCustomButton(AppLocalizations.of(context)!.speak, onTap: () {
              _viewModel.onPauseDialog();
              ref.read(appNavigatorProvider).navigateTo(
                    AppRoutes.pronunciationTopic,
                    arguments: state.sentences,
                  );
            }),
          ],
        ))
      ],
    );
  }

  Widget buildCustomButton(String text,
      {VoidCallback? onTap, bool isTurnOn = false}) {
    final isDarkTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isTurnOn
                ? Theme.of(context).primaryColor
                : isDarkTheme
                    ? Colors.grey[800]
                    : Colors.grey[200],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Text(text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: isTurnOn
                    ? Colors.white
                    : isDarkTheme
                        ? Colors.white
                        : Colors.black,
              )),
        ),
      ),
    );
  }

  Widget buildQuestionerMessage(bool isDarkTheme, TopicState state, int index) {
    final isExpandedTranslation = state.isExpandedTranslations[index];
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Stack(
            children: [
              _buildMessage(index, state, isDarkTheme, true),
              Positioned(
                  left: -5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        AppImages.questioner(width: ScreenUtil().setWidth(40)),
                  ))
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          _buildMessageIcon(
              index, isExpandedTranslation, state.sentences[index]),
        ],
      ),
    );
  }

  Widget buildRespondentMessage(
    bool isDarkTheme,
    TopicState state,
    int index,
  ) {
    final isExpandedTranslation = state.isExpandedTranslations[index];
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildMessageIcon(
              index, isExpandedTranslation, state.sentences[index]),
          const SizedBox(width: 8),
          Stack(
            children: [
              _buildMessage(index, state, isDarkTheme, false),
              Positioned(
                right: -5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppImages.respondent(width: ScreenUtil().setWidth(40)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(
      int index, TopicState state, bool isDarkTheme, bool isQuestioner) {
    final sentence = state.sentences[index];
    final isExpandedTranslation = state.isExpandedTranslations[index];
    final isPlaying = state.currentPlayingIndex == index;
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(16),
        bottom: ScreenUtil().setHeight(16),
        left: isQuestioner ? ScreenUtil().setWidth(48) : 0,
        right: isQuestioner ? 0 : ScreenUtil().setWidth(48),
      ),
      child: InkWell(
        onTap: () {
          _viewModel.onTapMessage(index);
        },
        child: Container(
          key: state.keys[index],
          width: ScreenUtil().screenWidth * 0.5,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: isPlaying
                ? Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  )
                : null,
            color: isPlaying
                ? Theme.of(context).primaryColor
                : isDarkTheme
                    ? Colors.grey[800]
                    : Colors.white,
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
            borderRadius: BorderRadius.only(
                topLeft: isQuestioner ? Radius.zero : const Radius.circular(16),
                topRight:
                    isQuestioner ? const Radius.circular(16) : Radius.zero,
                bottomRight: const Radius.circular(16),
                bottomLeft: const Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sentence.text,
                style: TextStyle(
                  color: isPlaying
                      ? Colors.white
                      : isDarkTheme
                          ? Colors.white
                          : Colors.black,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ),
              if (isExpandedTranslation)
                Text(
                  sentence.translation,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: isPlaying
                        ? Colors.grey[100]
                        : isDarkTheme
                            ? Colors.grey[400]
                            : Colors.grey[800],
                  ),
                  textAlign: TextAlign.justify,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageIcon(
      int index, bool isExpandedTranslation, Sentence sentence) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          height: ScreenUtil().setHeight(40),
          width: ScreenUtil().setWidth(40),
          onPressed: () {
            _viewModel.onTapExpandedTranslation(index);
          },
          icon: Icon(
            Icons.translate,
            size: ScreenUtil().setHeight(18),
          ),
        ),
        CustomIconButton(
          height: ScreenUtil().setHeight(40),
          width: ScreenUtil().setWidth(40),
          onPressed: () {
            _viewModel.onPauseDialog();
            ref
                .read(appNavigatorProvider)
                .navigateTo(AppRoutes.pronunciationPractice,
                    arguments: PronunciationPracticeViewArguments(
                      parentID: 0,
                      lessonEnum: LessonEnum.topic,
                      sentence: sentence,
                    ));
          },
          icon: Icon(
            Icons.mic,
            size: ScreenUtil().setHeight(18),
          ),
        ),
      ],
    );
  }
}
