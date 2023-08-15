import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_idiom_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';
import 'package:speak_up/presentation/widgets/definition_card/definition_card.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

final idiomLearningViewModelProvider = StateNotifierProvider.autoDispose<
    IdiomLearningViewModel, IdiomLearningState>(
  (ref) => IdiomLearningViewModel(
      injector.get<GetSentenceListFromIdiomUseCase>(),
      injector.get<PlayAudioFromUrlUseCase>(),
      injector.get<PlayAudioFromAssetUseCase>(),
      injector.get<PlayAudioFromFileUseCase>(),
      injector.get<StopAudioUseCase>(),
      injector.get<StartRecordingUseCase>(),
      injector.get<StopRecordingUseCase>(),
      injector.get<GetTextFromSpeechUseCase>()),
);

class IdiomLearningView extends ConsumerStatefulWidget {
  const IdiomLearningView({super.key});

  @override
  ConsumerState<IdiomLearningView> createState() => _IdiomLearningViewState();
}

class _IdiomLearningViewState extends ConsumerState<IdiomLearningView> {
  Idiom idiom = Idiom.initial();
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    idiom = ModalRoute.of(context)!.settings.arguments as Idiom;
    await ref.read(idiomLearningViewModelProvider.notifier).setIdiom(idiom);
    ref
        .read(idiomLearningViewModelProvider.notifier)
        .playAudio(idiom.audioEndpoint);
    await ref
        .read(idiomLearningViewModelProvider.notifier)
        .fetchExampleSentences();
    ref.read(idiomLearningViewModelProvider.notifier).updateTotalPage();
  }

  Future<void> onNextPageButtonTap() async {
    final state = ref.watch(idiomLearningViewModelProvider);
    ref.read(idiomLearningViewModelProvider.notifier).onStopRecording();
    if (_pageController.page!.toInt() == state.totalPage - 1) {
      ref
          .read(idiomLearningViewModelProvider.notifier)
          .updateCurrentPage(state.totalPage);
      Future.delayed(const Duration(milliseconds: 500), () {
        showCompleteBottomSheet();
      });
    } else {
      ref
          .read(idiomLearningViewModelProvider.notifier)
          .updateCurrentPage(_pageController.page!.toInt() + 1);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      ref.read(idiomLearningViewModelProvider.notifier).playAudio(
          state.exampleSentences[_pageController.page!.toInt()].audioEndpoint);
    }
  }

  void showExitBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: ScreenUtil().screenWidth,
            height: 250,
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              Flexible(child: Container()),
              Text(AppLocalizations.of(context)!.areYouSure,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                  text: AppLocalizations.of(context)!.exit,
                  fontWeight: FontWeight.bold,
                  textSize: 16,
                  marginVertical: 16,
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(appNavigatorProvider).pop();
                    ref
                        .read(idiomLearningViewModelProvider.notifier)
                        .stopAudio();
                  }),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Flexible(child: Container()),
            ]),
          );
        });
  }

  void showCompleteBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: ScreenUtil().screenWidth,
            height: 250,
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              Flexible(child: Container()),
              Text(AppLocalizations.of(context)!.congratulations,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                  text: AppLocalizations.of(context)!.exit,
                  fontWeight: FontWeight.bold,
                  textSize: 16,
                  marginVertical: 16,
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(appNavigatorProvider).pop();
                  }),
              Flexible(child: Container()),
            ]),
          );
        });
  }

  Future<void> onRecordButtonTap() async {
    final state = ref.watch(idiomLearningViewModelProvider);
    ref.read(idiomLearningViewModelProvider.notifier).stopAudio();
    if (state.recordButtonState == ButtonState.normal) {
      await ref
          .read(idiomLearningViewModelProvider.notifier)
          .onStartRecording();
    } else {
      final path = await ref
          .read(idiomLearningViewModelProvider.notifier)
          .onStopRecording();
      if (path != null) {
        ref
            .read(idiomLearningViewModelProvider.notifier)
            .getTextFromSpeech(path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomLearningViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: showExitBottomSheet,
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
        Text('Example $sentenceIndex:',
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
            ),
            CustomIconButton(
                icon: AppIcons.snail(
              size: 32,
              color: Colors.grey[800],
            )),
            Flexible(child: Container()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            sentence.text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
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
        SizedBox(
          height: ScreenUtil().setHeight(64),
        ),
      ],
    );
  }

  Center buildDefinitionIdiom(IdiomLearningState state, BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(32),
          ),
          DefinitionCard(
            name: state.idiom.name,
            description: state.idiom.description,
            descriptionTranslation: state.idiom.descriptionTranslation,
            tapFrontDescription:
                AppLocalizations.of(context)!.tapToSeeTheMeaning,
            tapBackDescription: AppLocalizations.of(context)!.tapToSeeTheIdiom,
            onPressed: () => ref
                .read(idiomLearningViewModelProvider.notifier)
                .playAudio(state.idiom.audioEndpoint),
          ),
          Flexible(child: Container()),
          buildBottomMenu(state.recordButtonState),
          SizedBox(
            height: ScreenUtil().setHeight(64),
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
