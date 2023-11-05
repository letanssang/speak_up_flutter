import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_slowly_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_state.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/pronunciation_buttons.dart';
import 'package:speak_up/presentation/widgets/cards/pronunciation_score_card.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:speak_up/presentation/widgets/text/pronunciation_score_text.dart';

final pronunciationPracticeViewModelProvider = StateNotifierProvider
    .autoDispose<PronunciationPracticeViewModel, PronunciationPracticeState>(
  (ref) => PronunciationPracticeViewModel(
    injector.get<GetSentenceListByParentIDUseCase>(),
    injector.get<SpeakFromTextUseCase>(),
    injector.get<SpeakFromTextSlowlyUseCase>(),
    injector.get<StartRecordingUseCase>(),
    injector.get<StopRecordingUseCase>(),
    injector.get<PlayAudioFromFileUseCase>(),
    injector.get<PlayCongratsAudioUseCase>(),
    injector.get<PlayCompleteAudioUseCase>(),
    injector.get<StopAudioUseCase>(),
    injector.get<GetPronunciationAssessmentUseCase>(),
    injector.get<UpdateProgressUseCase>(),
    injector.get<GetCurrentUserUseCase>(),
    ref,
  ),
);

class PronunciationPracticeViewArguments {
  final int parentID;
  final LessonEnum lessonEnum;
  final int? progress;
  final int? grandParentID;
  final Sentence? sentence;
  final bool canUpdateProgress;

  PronunciationPracticeViewArguments({
    required this.parentID,
    required this.lessonEnum,
    this.progress,
    this.grandParentID,
    this.sentence,
    this.canUpdateProgress = true,
  });
}

class PronunciationPracticeView extends ConsumerStatefulWidget {
  const PronunciationPracticeView({super.key});

  @override
  ConsumerState<PronunciationPracticeView> createState() =>
      _PronunciationPracticeViewState();
}

class _PronunciationPracticeViewState
    extends ConsumerState<PronunciationPracticeView> {
  int parentID = 0;
  LessonEnum lessonEnum = LessonEnum.pattern;
  int? progress;
  int? grandParentID;
  Sentence? sentence;
  bool canUpdateProgress = true;
  late PageController _pageController;

  PronunciationPracticeViewModel get _viewModel =>
      ref.read(pronunciationPracticeViewModelProvider.notifier);

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    final args = ModalRoute.of(context)!.settings.arguments
        as PronunciationPracticeViewArguments;
    parentID = args.parentID;
    lessonEnum = args.lessonEnum;
    progress = args.progress;
    grandParentID = args.grandParentID;
    sentence = args.sentence;
    canUpdateProgress = args.canUpdateProgress;
    await _viewModel.fetchSentenceList(parentID, lessonEnum,
        sentence: sentence);
    _viewModel.speakCurrentSentence();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> onNextButtonTap() async {
    _viewModel.updateCurrentIndex(_pageController.page!.toInt() + 1);
    _viewModel.resetStateWhenOnNextButtonTap();
    if (_pageController.page?.toInt() ==
        ref.watch(pronunciationPracticeViewModelProvider).sentences.length -
            1) {
      _viewModel.playCompleteAudio();
      showCompleteBottomSheet(context);
      final id = grandParentID ?? parentID;
      if (canUpdateProgress) {
        await _viewModel.updateProgress(id, lessonEnum, progress: progress);
      }
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _viewModel.speakCurrentSentence();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pronunciationPracticeViewModelProvider);
    final isDarkTheme = ref.read(themeProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showExitBottomSheet(context);
          },
          icon: const Icon(
            Icons.close_outlined,
            size: 32,
          ),
        ),
        title: AppLinearPercentIndicator(
          percent: state.loadingStatus == LoadingStatus.success
              ? state.currentIndex / state.sentences.length
              : 0,
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      AppImages.questioner(
                        width: ScreenUtil().setWidth(48),
                        height: ScreenUtil().setHeight(48),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Text(
                          state.pronunciationAssessmentStatus
                              .getAssistantText(context),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      height: ScreenUtil().setHeight(40),
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: ScreenUtil().setHeight(18),
                      ),
                      onPressed: () {
                        _viewModel
                            .speak(state.sentences[state.currentIndex].text);
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomIconButton(
                      height: ScreenUtil().setHeight(40),
                      icon: AppIcons.snail(
                        size: ScreenUtil().setHeight(16),
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        _viewModel.speakSlowly(
                            state.sentences[state.currentIndex].text);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.sentences.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildExampleItem(state, index);
                      },
                    ),
                  ),
                ),
                PronunciationScoreCard(
                  pronunciationScore: state.speechSentence?.pronScore ?? 0,
                  accuracyScore: state.speechSentence?.accuracyScore ?? 0,
                  fluencyScore: state.speechSentence?.fluencyScore ?? 0,
                  completenessScore:
                      state.speechSentence?.completenessScore ?? 0,
                ),
                const SizedBox(height: 16),
                PronunciationButtons(
                    recordPath: state.recordPath,
                    onPlayRecord: _viewModel.playRecord,
                    onRecordButtonTap: _viewModel.onRecordButtonTap,
                    onNextButtonTap: onNextButtonTap,
                    pronunciationAssessmentStatus:
                        state.pronunciationAssessmentStatus),
                const SizedBox(height: 16),
              ],
            )
          : state.loadingStatus == LoadingStatus.loading
              ? const AppLoadingIndicator()
              : const AppErrorView(),
    );
  }

  Widget _buildExampleItem(PronunciationPracticeState state, int index) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          state.sentences[index].text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: state.sentences[index].text.length < 50
                ? ScreenUtil().setSp(20)
                : ScreenUtil().setSp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        state.speechSentence?.words != null
            ? PronunciationScoreText(
                words: state.speechSentence?.words ?? [],
                recordPath: state.recordPath ?? '',
                fontSize: state.sentences[index].text.length < 50
                    ? ScreenUtil().setSp(20)
                    : ScreenUtil().setSp(16),
              )
            : Text(
                state.sentences[index].translation,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                ),
              ),
        Flexible(child: Container()),
      ],
    );
  }
}
