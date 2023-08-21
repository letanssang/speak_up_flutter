import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/quiz_result_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/cards/quiz_answer_card.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final quizViewModelProvider =
    StateNotifierProvider.autoDispose<QuizViewModel, QuizState>(
  (ref) => QuizViewModel(
    injector.get<GetIdiomListByTypeUseCase>(),
  ),
);

class QuizView extends ConsumerStatefulWidget {
  const QuizView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  late final LessonType _lessonType;
  late final dynamic parentType;
  final _pageViewController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _init();
    });
  }

  Future<void> _init() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _lessonType = args['lessonType'] as LessonType;
    parentType = args['parent'];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(quizViewModelProvider.notifier).init(_lessonType, parentType);
      await ref.read(quizViewModelProvider.notifier).fetchQuizzes();
    });
  }

  Future<void> showQuizResultBottomSheet() async {
    ref.listen(
        quizViewModelProvider.select((value) => value.quizAnswerCardStatus),
        (previous, next) {
      if (next == QuizAnswerCardStatus.after) {
        final state = ref.watch(quizViewModelProvider);
        showModalBottomSheet(
            isDismissible: false,
            useSafeArea: true,
            context: context,
            builder: (_) {
              return QuizResultBottomSheet(
                isCorrectAnswer: state.chosenAnswerIndex ==
                    state.quizzes[state.currentIndex].correctAnswerIndex,
                onTap: () {
                  ref.read(quizViewModelProvider.notifier).onNextQuestion();
                  Navigator.pop(context);
                  _pageViewController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                title: state.quizzes[state.currentIndex].question,
                correctAnswer: state.quizzes[state.currentIndex].answers[
                    state.quizzes[state.currentIndex].correctAnswerIndex],
              );
            });
      }
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizViewModelProvider);
    showQuizResultBottomSheet();
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: AppLinearPercentIndicator(
          percent: state.loadingStatus == LoadingStatus.success
              ? state.currentIndex / state.quizzes.length
              : 0,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_up_outlined),
          ),
        ],
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildLoadingSuccessBody()
          : state.loadingStatus == LoadingStatus.error
              ? Center(
                  child: Text(AppLocalizations.of(context)!.somethingWentWrong))
              : const Center(child: AppLoadingIndicator()),
    );
  }

  Widget buildLoadingSuccessBody() {
    final state = ref.watch(quizViewModelProvider);
    return PageView.builder(
      controller: _pageViewController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.quizzes.length,
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
                Text(state.quizzes[index].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    )),
                Flexible(child: Container()),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: ScreenUtil().screenHeight * 0.5),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, optionIndex) {
                      final quiz = state.quizzes[index];
                      return QuizAnswerCard(
                        index: optionIndex,
                        answer: quiz.answers[optionIndex],
                        isCorrectAnswer: quiz.correctAnswerIndex == optionIndex,
                        quizAnswerCardStatus: state.quizAnswerCardStatus,
                        onTap: () {
                          ref
                              .read(quizViewModelProvider.notifier)
                              .onSelectedAnswerOption(optionIndex);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: ScreenUtil().screenHeight * 0.05),
              ],
            ),
          ),
        );
      },
    );
  }
}
