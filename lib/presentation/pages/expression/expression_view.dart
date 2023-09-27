import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_expression_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/expression/expression_state.dart';
import 'package:speak_up/presentation/pages/expression/expression_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final expressionViewModelProvider =
    StateNotifierProvider.autoDispose<ExpressionViewModel, ExpressionState>(
  (ref) => ExpressionViewModel(
    injector.get<GetSentenceListFromExpressionUseCase>(),
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
        title: Text(language == Language.english
            ? expression.name
            : expression.translation),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? _buildLoadingSuccessBody(state, isDarkTheme)
          : state.loadingStatus == LoadingStatus.loading
              ? const AppLoadingIndicator()
              : state.loadingStatus == LoadingStatus.error
                  ? const AppErrorView()
                  : Container(),
    );
  }

  Widget _buildLoadingSuccessBody(ExpressionState state, bool isDarkTheme) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.sentences.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                child: Card(
                  elevation: 3,
                  color: isDarkTheme ? Colors.grey[850] : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: ListTile(
                    title: Text(
                      state.sentences[index].text,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      state.sentences[index].translation,
                      style: TextStyle(
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.volume_up_outlined,
                        color: Colors.grey[800],
                      ),
                      onPressed: () {
                        _viewModel
                            .playAudio(state.sentences[index].audioEndpoint);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        CustomButton(
            marginVertical: 16,
            text: AppLocalizations.of(context)!.practiceNow,
            onTap: null),
      ],
    );
  }
}
