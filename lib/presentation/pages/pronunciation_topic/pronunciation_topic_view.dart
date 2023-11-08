import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/pronunciation_assessment/get_pronunciation_assessment_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pronunciation_topic/pronunciation_topic_state.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/pronunciation_buttons.dart';
import 'package:speak_up/presentation/widgets/cards/pronunciation_score_card.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:speak_up/presentation/widgets/text/pronunciation_score_text.dart';

import 'pronunciation_topic_view_model.dart';

final pronunciationTopicProvider = StateNotifierProvider.autoDispose<
        PronunciationTopicViewModel, PronunciationTopicState>(
    (ref) => PronunciationTopicViewModel(
          injector.get<StopAudioUseCase>(),
          injector.get<StartRecordingUseCase>(),
          injector.get<StopRecordingUseCase>(),
          injector.get<PlayAudioFromFileUseCase>(),
          injector.get<GetPronunciationAssessmentUseCase>(),
          injector.get<PlayCongratsAudioUseCase>(),
          injector.get<PlayCompleteAudioUseCase>(),
        ));

class PronunciationTopicView extends ConsumerStatefulWidget {
  const PronunciationTopicView({super.key});

  @override
  ConsumerState<PronunciationTopicView> createState() =>
      _PronunciationTopicViewState();
}

class _PronunciationTopicViewState
    extends ConsumerState<PronunciationTopicView> {
  List<Sentence> sentences = [];

  PronunciationTopicViewModel get _viewModel =>
      ref.read(pronunciationTopicProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => init(),
    );
  }

  Future<void> init() async {
    sentences = ModalRoute.of(context)?.settings.arguments as List<Sentence>;
    _viewModel.updateSentenceList(sentences);
    _viewModel.speakCurrentQuestion();
  }

  void onNextButtonTap() {
    if (_viewModel.currentIndex < sentences.length ~/ 2 - 1) {
      _viewModel.onNextButtonTap();
      _viewModel.speakCurrentQuestion();
    } else {
      _viewModel.playCompleteAudio();
      showCompleteBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pronunciationTopicProvider);
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
          percent: sentences.isNotEmpty
              ? state.currentIndex / (sentences.length ~/ 2)
              : 0,
        ),
      ),
      body: sentences.isEmpty
          ? const AppLoadingIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildQuestionerMessage(
                  isDarkTheme,
                  sentences[state.currentIndex * 2],
                ),
                const SizedBox(height: 16),
                Text(
                    '${AppLocalizations.of(context)!.speakThisSentenceToAnswerTheQuestion}: ',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.isTranslatedAnswer
                        ? sentences[state.currentIndex * 2 + 1].translation
                        : sentences[state.currentIndex * 2 + 1].text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          sentences[state.currentIndex * 2 + 1].text.length < 50
                              ? ScreenUtil().setSp(20)
                              : ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold,
                    ),
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
                      onPressed: _viewModel.speakCurrentAnswer,
                    ),
                    const SizedBox(width: 8),
                    CustomIconButton(
                      height: ScreenUtil().setHeight(40),
                      icon: Icon(
                        Icons.translate_outlined,
                        size: ScreenUtil().setHeight(18),
                      ),
                      onPressed: _viewModel.onTranslateButtonTap,
                    ),
                  ],
                ),
                if (state.speechSentence?.words != null)
                  PronunciationScoreText(
                    words: state.speechSentence?.words ?? [],
                    recordPath: state.recordPath ?? '',
                    fontSize:
                        sentences[state.currentIndex * 2 + 1].text.length < 50
                            ? ScreenUtil().setSp(20)
                            : ScreenUtil().setSp(16),
                  ),
                Flexible(child: Container()),
                PronunciationScoreCard(
                  pronunciationScore: state.speechSentence?.pronScore ?? 0,
                  accuracyScore: state.speechSentence?.accuracyScore ?? 0,
                  fluencyScore: state.speechSentence?.fluencyScore ?? 0,
                  completenessScore:
                      state.speechSentence?.completenessScore ?? 0,
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                PronunciationButtons(
                    recordPath: state.recordPath,
                    onPlayRecord: _viewModel.playRecord,
                    onRecordButtonTap: _viewModel.onRecordButtonTap,
                    onNextButtonTap: onNextButtonTap,
                    pronunciationAssessmentStatus:
                        state.pronunciationAssessmentStatus),
                SizedBox(height: ScreenUtil().setHeight(16)),
              ],
            ),
    );
  }

  Widget buildQuestionerMessage(bool isDarkTheme, Sentence sentence) {
    return Stack(
      children: [
        _buildMessage(isDarkTheme, sentence),
        Positioned(
            left: -5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppImages.questioner(width: ScreenUtil().setWidth(40)),
            ))
      ],
    );
  }

  Widget _buildMessage(bool isDarkTheme, Sentence sentence) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: ScreenUtil().setWidth(48),
        right: 0,
      ),
      child: Container(
        width: ScreenUtil().screenWidth * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
          color: isDarkTheme ? Colors.grey[700] : Colors.white,
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
        child: Text(
          sentence.text,
          style: TextStyle(
            color: isDarkTheme ? Colors.white : Theme.of(context).primaryColor,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
