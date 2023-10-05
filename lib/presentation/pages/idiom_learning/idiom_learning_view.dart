import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_slow_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_idiom_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_view.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';
import 'package:speak_up/presentation/widgets/cards/flash_card_item.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

final idiomLearningViewModelProvider = StateNotifierProvider.autoDispose<
    IdiomLearningViewModel, IdiomLearningState>(
  (ref) => IdiomLearningViewModel(
      injector.get<GetSentenceListByParentIDUseCase>(),
      injector.get<PlayAudioFromUrlUseCase>(),
      injector.get<PlaySlowAudioFromUrlUseCase>(),
      injector.get<PlayAudioFromAssetUseCase>(),
      injector.get<PlayAudioFromFileUseCase>(),
      injector.get<StopAudioUseCase>(),
      injector.get<StartRecordingUseCase>(),
      injector.get<StopRecordingUseCase>(),
      injector.get<GetTextFromSpeechUseCase>(),
      injector.get<SpeakFromTextUseCase>(),
      injector.get<UpdateIdiomProgressUseCase>(),
      injector.get<GetCurrentUserUseCase>()),
);

class IdiomLearningView extends ConsumerStatefulWidget {
  const IdiomLearningView({super.key});

  @override
  ConsumerState<IdiomLearningView> createState() => _IdiomLearningViewState();
}

class _IdiomLearningViewState extends ConsumerState<IdiomLearningView> {
  Idiom idiom = Idiom.initial();
  final _pageController = PageController(initialPage: 0);
  int process = 0;
  int index = 0;

  IdiomLearningViewModel get _viewModel =>
      ref.read(idiomLearningViewModelProvider.notifier);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    //argument: <String, dynamic> {idiom: idiom, process: process, index: index}
    final argument =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    idiom = argument['idiom'] as Idiom;
    process = argument['progress'] as int;
    index = argument['index'] as int;

    _viewModel.speakFromText(idiom.name);
    await _viewModel.fetchExampleSentences(idiom);
    _viewModel.updateTotalPage();
  }

  Future<void> onNextPageButtonTap() async {
    if (_viewModel.isAnimating || _viewModel.isLastPage) return;
    _viewModel.updateAnimatingState(true);
    _viewModel.onStopRecording();

    _viewModel.updateCurrentPage(
        ref.read(idiomLearningViewModelProvider).currentPage + 1);
    if (_viewModel.isLastPage) {
      if (index == process) {
        _viewModel.updateIdiomProgress(process, idiom.idiomTypeID);
        await ref
            .read(idiomViewModelProvider.notifier)
            .updateProgressState(process);
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        showCompleteBottomSheet(context);
      });
    } else {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _viewModel.playAudio(ref
          .read(idiomLearningViewModelProvider)
          .exampleSentences[_pageController.page!.toInt()]
          .audioEndpoint);
    }
    ref
        .read(idiomLearningViewModelProvider.notifier)
        .updateAnimatingState(false);
  }

  Future<void> onPlayRecordButtonTap() async {
    await _viewModel.playRecord();
  }

  Future<void> onRecordButtonTap() async {
    final state = ref.watch(idiomLearningViewModelProvider);
    _viewModel.stopAudio();
    if (state.recordButtonState == ButtonState.normal) {
      await ref
          .read(idiomLearningViewModelProvider.notifier)
          .onStartRecording();
    } else {
      await _viewModel.onStopRecording();
      await ref
          .read(idiomLearningViewModelProvider.notifier)
          .getTextFromSpeech();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomLearningViewModelProvider);
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
          buildDefinitionIdiom(state, context),
          if (state.loadingStatus == LoadingStatus.success)
            ...state.exampleSentences.map(
              (sentence) => buildExampleIdiom(
                  sentence,
                  state.exampleSentences.indexOf(sentence) + 1,
                  state.recordButtonState,
                  onRecordButtonTap),
            ),
        ],
      ),
    );
  }

  Widget buildExampleIdiom(Sentence sentence, int sentenceIndex,
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
              onPressed: () => ref
                  .read(idiomLearningViewModelProvider.notifier)
                  .playAudio(sentence.audioEndpoint),
            ),
            CustomIconButton(
                icon: AppIcons.snail(
                  size: 32,
                  color: Colors.grey[800],
                ),
                onPressed: () => ref
                    .read(idiomLearningViewModelProvider.notifier)
                    .playSlowAudio(sentence.audioEndpoint)),
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

  Center buildDefinitionIdiom(IdiomLearningState state, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          FlashCardItem(
            frontText: idiom.name,
            backText: idiom.description,
            backTranslation: idiom.descriptionTranslation,
            tapFrontDescription:
                AppLocalizations.of(context)!.tapToSeeTheMeaning,
            tapBackDescription: AppLocalizations.of(context)!.tapToReturn,
            onPressedFrontCard: () => ref
                .read(idiomLearningViewModelProvider.notifier)
                .speakFromText(idiom.name),
            onPressedBackCard: () => ref
                .read(idiomLearningViewModelProvider.notifier)
                .speakFromText(idiom.description),
          ),
          Flexible(child: Container()),
          buildBottomMenu(state.recordButtonState),
          const SizedBox(
            height: 64,
          ),
        ],
      ),
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
