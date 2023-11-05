import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/quiz/quiz.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_complete_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_congrats_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/quiz_result_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/cards/quiz_answer_card.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

final quizViewModelProvider =
    StateNotifierProvider.autoDispose<QuizViewModel, QuizState>(
  (ref) => QuizViewModel(
    injector.get<SpeakFromTextUseCase>(),
    injector.get<PlayCongratsAudioUseCase>(),
    injector.get<PlayCompleteAudioUseCase>(),
  ),
);

class QuizView extends ConsumerStatefulWidget {
  const QuizView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  List<Quiz> _quizzes = [];

  QuizViewModel get _viewModel => ref.read(quizViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _quizzes = ModalRoute.of(context)!.settings.arguments as List<Quiz>;
      ();
      setState(() {});
    });
  }

  Future<void> showQuizResultBottomSheet() async {
    ref.listen(
        quizViewModelProvider.select((value) => value.quizAnswerCardStatus),
        (previous, next) {
      if (next == QuizAnswerCardStatus.after) {
        final state = ref.watch(quizViewModelProvider);
        final isCorrectAnswer = state.chosenAnswerIndex ==
            _quizzes[state.currentIndex].correctAnswerIndex;
        if (isCorrectAnswer) {
          _viewModel.playCongratsAudio();
        }
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            showModalBottomSheet(
                enableDrag: false,
                isDismissible: false,
                useSafeArea: true,
                context: context,
                builder: (_) {
                  return QuizResultBottomSheet(
                    isCorrectAnswer: isCorrectAnswer,
                    onTap: () {
                      _viewModel.onNextQuestion();
                      Navigator.pop(context);
                      if (state.currentIndex < _quizzes.length - 1) {
                        _viewModel.pageViewController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _viewModel.playCompleteAudio();
                        // title: number of correct answers / total number of questions
                        showCompleteBottomSheet(context,
                            title:
                                '${AppLocalizations.of(context)!.youGot} ${state.correctAnswerNumber}/${_quizzes.length} ${AppLocalizations.of(context)!.correctAnswers}');
                      }
                    },
                    title: _quizzes[state.currentIndex].question,
                    correctAnswer: _quizzes[state.currentIndex].answers[
                        _quizzes[state.currentIndex].correctAnswerIndex],
                  );
                });
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizViewModelProvider);
    showQuizResultBottomSheet();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showExitBottomSheet(context);
          },
          icon: Icon(
            Icons.close_outlined,
            size: ScreenUtil().setHeight(24),
          ),
        ),
        title: AppLinearPercentIndicator(
          percent:
              _quizzes.isNotEmpty ? state.currentIndex / _quizzes.length : 0,
        ),
      ),
      body: _quizzes.isNotEmpty
          ? buildLoadingSuccessBody()
          : const AppLoadingIndicator(),
    );
  }

  Widget buildLoadingSuccessBody() {
    final state = ref.watch(quizViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    return PageView.builder(
      controller: _viewModel.pageViewController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quizzes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.chooseTheCorrectMeaningOf,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                Text(_quizzes[index].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    )),
                const SizedBox(height: 16.0),
                CustomIconButton(
                  height: ScreenUtil().setHeight(40),
                  width: ScreenUtil().setWidth(40),
                  icon: Icon(
                    Icons.volume_up_outlined,
                    size: ScreenUtil().setWidth(18),
                  ),
                  onPressed: () {
                    _viewModel.speak(_quizzes[index].question);
                  },
                ),
                Flexible(child: Container()),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: ScreenUtil().screenHeight * 0.5),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: ScreenUtil().setWidth(8),
                      mainAxisSpacing: ScreenUtil().setHeight(8),
                      childAspectRatio: ScreenUtil().screenWidth /
                          (ScreenUtil().screenHeight * 0.5),
                    ),
                    itemCount: 4,
                    itemBuilder: (context, optionIndex) {
                      final quiz = _quizzes[index];
                      return QuizAnswerCard(
                        index: optionIndex,
                        answer: quiz.answers[optionIndex],
                        isCorrectAnswer: quiz.correctAnswerIndex == optionIndex,
                        quizAnswerCardStatus: state.quizAnswerCardStatus,
                        onTap: () {
                          _viewModel.onSelectedAnswerOption(
                              quiz.correctAnswerIndex, optionIndex);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
