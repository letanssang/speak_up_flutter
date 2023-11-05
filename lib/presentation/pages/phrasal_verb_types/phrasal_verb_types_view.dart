import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_type_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/phrasal_verb_types/phrasal_verb_types_state.dart';
import 'package:speak_up/presentation/pages/phrasal_verb_types/phrasal_verb_types_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/learning_mode_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final phrasalVerbTypesViewModelProvider = StateNotifierProvider.autoDispose<
    PhrasalVerbTypesViewModel, PhrasalVerbTypesState>(
  (ref) => PhrasalVerbTypesViewModel(
    injector.get<GetPhrasalVerbTypeListUseCase>(),
    injector.get<GetPhrasalVerbListByTypeUseCase>(),
    injector.get<GetCurrentUserUseCase>(),
  ),
);

class PhrasalVerbTypesView extends ConsumerStatefulWidget {
  const PhrasalVerbTypesView({super.key});

  @override
  ConsumerState<PhrasalVerbTypesView> createState() =>
      _PhrasalVerbTypesViewState();
}

class _PhrasalVerbTypesViewState extends ConsumerState<PhrasalVerbTypesView> {
  PhrasalVerbTypesViewModel get _viewModel =>
      ref.read(phrasalVerbTypesViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    await _viewModel.getPhrasalVerbList();
  }

  void showOptionButtonSheet(int index) {
    final phrasalVerbType =
        ref.read(phrasalVerbTypesViewModelProvider).phrasalVerbTypes[index];
    showModalBottomSheet(
        context: context,
        builder: (context) => LearningModeBottomSheet(
              title: phrasalVerbType.name,
              onTapLecture: () {
                ref.read(appNavigatorProvider).navigateTo(AppRoutes.phrasalVerb,
                    arguments: phrasalVerbType);
              },
              onTapQuiz: () async {
                final quizzes = await _viewModel.getQuizzesByPhrasalVerbTypeID(
                    phrasalVerbType.phrasalVerbTypeID);
                ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.quiz,
                      arguments: quizzes,
                    );
              },
              onTapFlashcard: () async {
                final flashCards =
                    await _viewModel.getFlashCardByPhrasalVerbTypeID(
                        phrasalVerbType.phrasalVerbTypeID);
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.flashCards, arguments: flashCards);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phrasalVerbTypesViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return ListView.builder(
          itemCount: state.phrasalVerbTypes.length,
          itemBuilder: (context, index) {
            return AppListTile(
              index: index,
              onTap: () {
                showOptionButtonSheet(index);
              },
              title: language == Language.english
                  ? state.phrasalVerbTypes[index].name
                  : state.phrasalVerbTypes[index].translation,
            );
          },
        );
      case LoadingStatus.error:
        return const AppErrorView();
      default:
        return const Center(child: AppLoadingIndicator());
    }
  }
}
