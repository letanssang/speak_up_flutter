import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_pattern_done_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_state.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final patternLessonDetailViewModelProvider = StateNotifierProvider.autoDispose<
    PatternLessonDetailViewModel, PatternLessonDetailState>((ref) {
  return PatternLessonDetailViewModel(
    injector.get<GetSentencePatternListUseCase>(),
    injector.get<GetPatternDoneListUseCase>(),
  );
});

class PatternLessonDetailView extends ConsumerStatefulWidget {
  const PatternLessonDetailView({super.key});

  @override
  ConsumerState<PatternLessonDetailView> createState() =>
      _PatternLessonDetailViewState();
}

class _PatternLessonDetailViewState
    extends ConsumerState<PatternLessonDetailView> {
  PatternLessonDetailViewModel get _viewModel =>
      ref.read(patternLessonDetailViewModelProvider.notifier);

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    await _viewModel.fetchSentencePatternList();
    await _viewModel.fetchPatternDoneList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternLessonDetailViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return ListView.builder(
          itemCount: state.sentencePatterns.length,
          itemBuilder: (context, index) {
            return AppListTile(
              index: index,
              onTap: () {
                ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.pattern,
                      arguments: state.sentencePatterns[index],
                    );
              },
              title: state.sentencePatterns[index].name,
              trailing: state.progressLoadingStatus == LoadingStatus.success &&
                      state.isDoneList[index]
                  ? Icon(
                      Icons.check_outlined,
                      size: ScreenUtil().setSp(24),
                      color: isDarkTheme
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    )
                  : null,
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
