import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_state.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view_model.dart';
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
    injector.get<StartRecordingUseCase>(),
    injector.get<StopRecordingUseCase>(),
    injector.get<PlayAudioFromFileUseCase>(),
    injector.get<PlayCongratsAudioUseCase>(),
    injector.get<PlayCompleteAudioUseCase>(),
    injector.get<GetPronunciationAssessmentUseCase>(),
    ref,
  ),
);

class PronunciationPracticeViewArguments {
  final int parentID;
  final LessonEnum lessonEnum;

  PronunciationPracticeViewArguments({
    required this.parentID,
    required this.lessonEnum,
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
    await _viewModel.fetchSentenceList(parentID, lessonEnum);
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
      showCompleteBottomSheet(context);
      await _viewModel.updateProgress(parentID, lessonEnum);
      //Todo: fetch progress
      _viewModel.playCompleteAudio();
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
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      AppImages.questioner(
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Text(
                          state.pronunciationAssessmentStatus
                              .getAssistantText(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                const SizedBox(height: 32),
                PronunciationButtons(
                    recordPath: state.recordPath,
                    onPlayRecord: _viewModel.playRecord,
                    onRecordButtonTap: _viewModel.onRecordButtonTap,
                    onNextButtonTap: onNextButtonTap,
                    pronunciationAssessmentStatus:
                        state.pronunciationAssessmentStatus),
                const SizedBox(height: 48),
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
        CustomIconButton(
          height: 40,
          icon: Icon(
            Icons.volume_up_outlined,
            size: 20,
            color: Colors.grey[800],
          ),
          onPressed: () {
            _viewModel.speak(state.sentences[index].text);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            state.sentences[index].text,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        state.speechSentence?.words != null
            ? PronunciationScoreText(
                words: state.speechSentence?.words ?? [],
                recordPath: state.recordPath ?? '',
                fontSize: 20,
              )
            : Text(
                state.sentences[index].translation,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
        Flexible(child: Container()),
      ],
    );
  }
}
