import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_pattern_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pattern_learning/pattern_learning_state.dart';
import 'package:speak_up/presentation/pages/pattern_learning/pattern_learning_view_model.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_view.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final patternLearningViewModelProvider = StateNotifierProvider.autoDispose<
    PatternLearningViewModel, PatternLearningState>(
  (ref) => PatternLearningViewModel(
    injector.get<GetSentenceListByParentIDUseCase>(),
    injector.get<StopAudioUseCase>(),
    injector.get<StartRecordingUseCase>(),
    injector.get<StopRecordingUseCase>(),
    injector.get<PlayAudioFromAssetUseCase>(),
    injector.get<PlayAudioFromFileUseCase>(),
    injector.get<GetTextFromSpeechUseCase>(),
    injector.get<SpeakFromTextUseCase>(),
    injector.get<UpdatePatternProgressUseCase>(),
    injector.get<GetCurrentUserUseCase>(),
  ),
);

class PatternLearningView extends ConsumerStatefulWidget {
  const PatternLearningView({super.key});

  @override
  ConsumerState<PatternLearningView> createState() =>
      _PatternLearningViewState();
}

class _PatternLearningViewState extends ConsumerState<PatternLearningView> {
  SentencePattern pattern = SentencePattern.initial();
  final _pageController = PageController(initialPage: 0);
  int process = 0;
  int index = 0;

  PatternLearningViewModel get _viewModel =>
      ref.read(patternLearningViewModelProvider.notifier);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _init();
    });
  }

  Future<void> onNextPageButtonTap() async {
    if (_viewModel.isAnimating || _viewModel.isLastPage) return;
    _viewModel.updateAnimatingState(true);
    _viewModel.stopAudio();

    _viewModel.updateCurrentPage(
        ref.read(patternLearningViewModelProvider).currentPage + 1);
    if (_viewModel.isLastPage) {
      await _viewModel.updatePatternProgress(pattern.patternID);
      await ref
          .read(patternLessonDetailViewModelProvider.notifier)
          .fetchPatternDoneList();
      Future.delayed(const Duration(milliseconds: 500), () {
        showCompleteBottomSheet(context);
      });
    } else {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _viewModel.speakFromText(ref
          .read(patternLearningViewModelProvider)
          .exampleSentences[index]
          .text);
    }
    _viewModel.updateAnimatingState(false);
  }

  Future<void> onPlayRecordButtonTap() async {
    await _viewModel.playRecord();
  }

  Future<void> onRecordButtonTap() async {
    final state = ref.watch(patternLearningViewModelProvider);
    _viewModel.stopAudio();
    if (state.recordButtonState == ButtonState.normal) {
      await _viewModel.onStartRecording();
    } else {
      await _viewModel.onStopRecording();
      await _viewModel.getTextFromSpeech();
    }
  }

  Future<void> _init() async {
    pattern = ModalRoute.of(context)!.settings.arguments as SentencePattern;
    await _viewModel.fetchExampleSentences(pattern);
    _viewModel.updateTotalPage();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternLearningViewModelProvider);
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
        title: state.loadingStatus == LoadingStatus.success
            ? AppLinearPercentIndicator(
                percent: state.currentPage / state.totalPage,
              )
            : const AppLinearPercentIndicator(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_up_outlined),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (state.loadingStatus == LoadingStatus.success)
            ...state.exampleSentences.map(
              (sentence) => buildExample(
                  sentence,
                  state.exampleSentences.indexOf(sentence) + 1,
                  state.recordButtonState,
                  onRecordButtonTap),
            ),
        ],
      ),
    );
  }

  Widget buildExample(Sentence sentence, int sentenceIndex,
      ButtonState buttonState, Function()? onRecordButtonTap) {
    return Column(
      children: [
        SizedBox(
          height: ScreenUtil().setHeight(32),
        ),
        Text('${AppLocalizations.of(context)!.example} $sentenceIndex:',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              fontWeight: FontWeight.bold,
            )),
        Row(
          children: [
            Flexible(child: Container()),
            CustomIconButton(
              icon: Icon(
                Icons.volume_up_outlined,
                size: 32,
                color: Colors.grey[800],
              ),
              onPressed: () => _viewModel.speakFromText(sentence.text),
            ),
            Flexible(child: Container()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            sentence.text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            sentence.translation,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              color: Colors.grey[700],
            ),
          ),
        ),
        Flexible(child: Container()),
        buildBottomMenu(buttonState),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }

  Widget buildBottomMenu(ButtonState buttonState) {
    return Row(
      children: [
        Flexible(child: Container()),
        CustomIconButton(
          onPressed: onPlayRecordButtonTap,
          height: 64,
          width: 64,
          icon: AppIcons.playRecord(
            size: 32,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(
          width: 32,
        ),
        RecordButton(
          buttonState: buttonState,
          onTap: onRecordButtonTap,
        ),
        const SizedBox(
          width: 32,
        ),
        CustomIconButton(
            height: 64,
            width: 64,
            onPressed: onNextPageButtonTap,
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
