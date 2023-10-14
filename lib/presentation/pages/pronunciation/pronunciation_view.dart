import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_word_list_by_phonetic_id_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_state.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assesment_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';
import 'package:speak_up/presentation/widgets/cards/pronunciation_score_card.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:speak_up/presentation/widgets/text/pronunciation_score_text.dart';

final pronunciationViewModelProvider = StateNotifierProvider.autoDispose<
    PronunciationViewModel, PronunciationState>(
  (ref) => PronunciationViewModel(
    injector.get<GetWordListByPhoneticIDUSeCase>(),
    injector.get<SpeakFromTextUseCase>(),
    injector.get<StartRecordingUseCase>(),
    injector.get<StopRecordingUseCase>(),
    injector.get<PlayAudioFromFileUseCase>(),
    injector.get<GetPronunciationAssessmentUseCase>(),
  ),
);

class PronunciationView extends ConsumerStatefulWidget {
  const PronunciationView({super.key});

  @override
  ConsumerState<PronunciationView> createState() => _PronunciationViewState();
}

class _PronunciationViewState extends ConsumerState<PronunciationView> {
  int phoneticID = 0;
  late PageController _pageController;

  PronunciationViewModel get _viewModel =>
      ref.read(pronunciationViewModelProvider.notifier);

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
    phoneticID = ModalRoute.of(context)!.settings.arguments as int;
    await _viewModel.fetchWordList(phoneticID);
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
        ref.watch(pronunciationViewModelProvider).wordList.length - 1) {
      showCompleteBottomSheet(context);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pronunciationViewModelProvider);
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
              ? state.currentIndex / state.wordList.length
              : 0,
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? Column(
              children: [
                RefreshIndicator(child: Container(), onRefresh: () async {}),
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
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.wordList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Flexible(child: Container()),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.wordList[index].word,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: CustomIconButton(
                                  height: 40,
                                  icon: Icon(
                                    Icons.volume_up_outlined,
                                    size: 20,
                                    color: Colors.grey[800],
                                  ),
                                  onPressed: () {
                                    _viewModel
                                        .speak(state.wordList[index].word);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            state.wordList[index].translation,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (state.speechSentence?.words != null)
                            PronunciationScoreText(
                              words: state.speechSentence?.words ?? [],
                              recordPath: state.recordPath ?? '',
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                          Flexible(child: Container()),
                        ],
                      );
                    },
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
                buildBottomMenu(state),
                const SizedBox(height: 64),
              ],
            )
          : state.loadingStatus == LoadingStatus.loading
              ? const AppLoadingIndicator()
              : const AppErrorView(),
    );
  }

  Row buildBottomMenu(PronunciationState state) {
    return Row(
      children: [
        Flexible(child: Container()),
        state.recordPath != null
            ? CustomIconButton(
                onPressed: () {
                  _viewModel.playRecord();
                },
                height: 64,
                width: 64,
                icon: AppIcons.playRecord(
                  size: 32,
                  color: Colors.grey[800],
                ),
              )
            : const SizedBox(
                width: 64,
                height: 64,
              ),
        const SizedBox(
          width: 32,
        ),
        RecordButton(
          buttonState: state.pronunciationAssessmentStatus.getButtonState(),
          onTap: _viewModel.onRecordButtonTap,
        ),
        const SizedBox(
          width: 32,
        ),
        CustomIconButton(
            height: 64,
            width: 64,
            onPressed: () {
              onNextButtonTap();
            },
            icon: Icon(
              Icons.navigate_next_outlined,
              size: 32,
              color: Colors.grey[800],
            )),
        Flexible(child: Container()),
      ],
    );
  }
}
