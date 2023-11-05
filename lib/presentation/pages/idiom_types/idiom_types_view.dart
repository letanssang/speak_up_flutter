import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_type_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_state.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/learning_mode_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final idiomTypesViewModelProvider =
    StateNotifierProvider.autoDispose<IdiomTypesViewModel, IdiomTypesState>(
  (ref) => IdiomTypesViewModel(
    injector.get<GetIdiomTypeListUseCase>(),
    injector.get<GetCurrentUserUseCase>(),
    injector.get<GetIdiomListByTypeUseCase>(),
  ),
);

class IdiomTypesView extends ConsumerStatefulWidget {
  const IdiomTypesView({super.key});

  @override
  ConsumerState<IdiomTypesView> createState() => _IdiomTypesViewState();
}

class _IdiomTypesViewState extends ConsumerState<IdiomTypesView> {
  IdiomTypesViewModel get _viewModel =>
      ref.read(idiomTypesViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    await _viewModel.fetchIdiomTypeList();
  }

  void showOptionButtonSheet(int index) {
    final idiomType = ref.read(idiomTypesViewModelProvider).idiomTypes[index];
    showModalBottomSheet(
        context: context,
        builder: (context) => LearningModeBottomSheet(
              title: idiomType.name,
              onTapLecture: () {
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.idiom, arguments: idiomType);
              },
              onTapQuiz: () async {
                final quizzes = await _viewModel.getQuizzesByIdiomTypeID(
                  ref
                      .read(idiomTypesViewModelProvider)
                      .idiomTypes[index]
                      .idiomTypeID,
                );
                ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.quiz,
                      arguments: quizzes,
                    );
              },
              onTapFlashcard: () async {
                final flashCards = await _viewModel.getFlashCardByIdiomTypeID(
                  ref
                      .read(idiomTypesViewModelProvider)
                      .idiomTypes[index]
                      .idiomTypeID,
                );
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.flashCards, arguments: flashCards);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomTypesViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return ListView.builder(
          itemCount: state.idiomTypes.length,
          itemBuilder: (context, index) {
            return AppListTile(
              index: index,
              onTap: () {
                showOptionButtonSheet(index);
              },
              title: language == Language.english
                  ? state.idiomTypes[index].name
                  : state.idiomTypes[index].translation,
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
