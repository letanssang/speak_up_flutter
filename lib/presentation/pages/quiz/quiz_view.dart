import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_state.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/cards/quiz_answer_card.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: AppLinearPercentIndicator(
          percent: state.loadingStatus == LoadingStatus.success
              ? state.currentIndex / state.quizzes.length
              : 0,
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildLoadingSuccessBody()
          : state.loadingStatus == LoadingStatus.error
              ? const Center(child: Text('Something went wrong'))
              : const Center(child: AppLoadingIndicator()),
    );
  }

  Widget buildLoadingSuccessBody() {
    final state = ref.watch(quizViewModelProvider);
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.quizzes.length,
      itemBuilder: (context, index) {
        return Center(
          child: Column(
            children: [
              const Text('Question'),
              const SizedBox(height: 10.0),
              Text(state.quizzes[index].question),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 1.2,
                      ),
                      children: state.quizzes[index].answers
                          .asMap()
                          .entries
                          .map((e) => QuizAnswerCard(
                                index: e.key,
                                answer: e.value,
                                isCorrectAnswer: e.key ==
                                    state.quizzes[index].correctAnswerIndex,
                              ))
                          .toList()),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
