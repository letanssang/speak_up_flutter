import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/expression/expression_state.dart';
import 'package:speak_up/presentation/pages/expression/expression_view_model.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final expressionViewModelProvider =
    StateNotifierProvider.autoDispose<ExpressionViewModel, ExpressionState>(
  (ref) => ExpressionViewModel(
    injector.get<GetSentenceListByParentIDUseCase>(),
    injector.get<PlayAudioFromUrlUseCase>(),
  ),
);

class ExpressionView extends ConsumerStatefulWidget {
  const ExpressionView({super.key});

  @override
  ConsumerState<ExpressionView> createState() => _ExpressionViewState();
}

class _ExpressionViewState extends ConsumerState<ExpressionView> {
  Expression expression = Expression.initial();

  ExpressionViewModel get _viewModel =>
      ref.read(expressionViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    expression = ModalRoute.of(context)!.settings.arguments as Expression;
    await _viewModel.fetchSentences(expression.expressionID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expressionViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
            language == Language.english
                ? expression.name
                : expression.translation,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
            )),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? _buildLoadingSuccessBody(state, isDarkTheme)
          : state.loadingStatus == LoadingStatus.error
              ? const AppErrorView()
              : const AppLoadingIndicator(),
    );
  }

  Widget _buildLoadingSuccessBody(ExpressionState state, bool isDarkTheme) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.sentences.length,
            itemBuilder: (context, index) {
              return AppListTile(
                index: index,
                title: state.sentences[index].text,
                subtitle: state.sentences[index].translation,
                leading: const SizedBox(),
                trailing: IconButton(
                  icon: Icon(
                    Icons.volume_up_outlined,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    size: ScreenUtil().setSp(24),
                  ),
                  onPressed: () {
                    _viewModel.playAudio(state.sentences[index].audioEndpoint);
                  },
                ),
              );
            },
          ),
        ),
        CustomButton(
            marginVertical: 16,
            text: AppLocalizations.of(context)!.practiceNow,
            onTap: () {
              ref.read(appNavigatorProvider).navigateTo(
                  AppRoutes.pronunciationPractice,
                  arguments: PronunciationPracticeViewArguments(
                      parentID: expression.expressionID,
                      lessonEnum: LessonEnum.expression));
            }),
        const SizedBox(height: 16),
      ],
    );
  }
}
