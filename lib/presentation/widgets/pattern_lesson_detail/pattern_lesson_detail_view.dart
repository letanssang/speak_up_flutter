import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/pattern_lesson_detail/pattern_lesson_detail_state.dart';
import 'package:speak_up/presentation/widgets/pattern_lesson_detail/pattern_lesson_detail_view_model.dart';

final patternLessonDetailViewModelProvider = StateNotifierProvider.autoDispose<
    PatternLessonDetailViewModel, PatternLessonDetailState>((ref) {
  return PatternLessonDetailViewModel(
    injector.get<GetSentencePatternListUseCase>(),
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
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    await ref
        .read(patternLessonDetailViewModelProvider.notifier)
        .fetchSentencePatternList();
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 3,
                color: isDarkTheme ? Colors.grey[850] : Colors.white,
                surfaceTintColor: Colors.white,
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    state.sentencePatterns[index].name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.play_circle_outline_outlined,
                    size: 32,
                    color: isDarkTheme
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        );
      case LoadingStatus.error:
        return const Center(child: Text('Error'));
      default:
        return const Center(child: AppLoadingIndicator());
    }
  }
}
