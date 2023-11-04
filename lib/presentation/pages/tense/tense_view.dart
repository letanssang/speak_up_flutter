import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/tense/tense.dart';
import 'package:speak_up/domain/entities/tense_usage/tense_usage.dart';
import 'package:speak_up/domain/use_cases/local_database/get_tense_form_list_from_tense_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_tense_usage_list_from_tense_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/tense/tense_state.dart';
import 'package:speak_up/presentation/pages/tense/tense_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final tenseViewModelProvider =
    StateNotifierProvider.autoDispose<TenseViewModel, TenseState>(
  (ref) => TenseViewModel(
    injector.get<GetTenseFormListFromTenseUseCase>(),
    injector.get<GetTenseUsageListFromTenseUseCase>(),
  ),
);

class TenseView extends ConsumerStatefulWidget {
  const TenseView({super.key});

  @override
  ConsumerState<TenseView> createState() => _TenseViewState();
}

class _TenseViewState extends ConsumerState<TenseView> {
  Tense tense = Tense.initial();

  TenseViewModel get _viewModel => ref.watch(tenseViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    tense = ModalRoute.of(context)!.settings.arguments as Tense;
    setState(() {});
    await _viewModel.getTenseData(tense.tenseID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tenseViewModelProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
            language == Language.english ? tense.tense : tense.translation),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildLoadingSuccessBody(state)
          : state.loadingStatus == LoadingStatus.error
              ? const AppErrorView()
              : const AppLoadingIndicator(),
    );
  }

  Widget buildLoadingSuccessBody(TenseState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildHeaderText(AppLocalizations.of(context)!.form),
            _buildFormTable(state),
            _buildHeaderText(AppLocalizations.of(context)!.usages),
            _buildUsages(state.tenseUsages),
            _buildHeaderText(AppLocalizations.of(context)!.signalWords),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  Text(tense.signalWords, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUsages(List<TenseUsage> tenseUsages) {
    return Column(
      children: [
        ...tenseUsages.map(
          (e) => _buildUsageItem(e),
        ),
      ],
    );
  }

  Widget _buildUsageItem(TenseUsage e) {
    final language = ref.watch(appLanguageProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  language == Language.english
                      ? e.description
                      : e.descriptionTranslation,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 20),
              const Icon(Icons.arrow_forward, size: 16),
              const SizedBox(width: 8),
              Flexible(
                  child: Text(e.example, style: const TextStyle(fontSize: 16))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormTable(TenseState state) {
    final isDarkTheme = ref.watch(themeProvider);
    return Center(
      child: Table(
        // first column width min
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder.all(),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDarkTheme ? Colors.grey[700] : Colors.grey[300],
            ),
            children: [
              const SizedBox(),
              ...state.tenseForms.map(
                (e) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          TableRow(children: [
            _buildFistCell(
                AppLocalizations.of(context)!.positive, context, isDarkTheme),
            ...state.tenseForms
                .map((e) => _buildTableCell(e.positive, e.positiveExample)),
          ]),
          TableRow(children: [
            _buildFistCell(
                AppLocalizations.of(context)!.negative, context, isDarkTheme),
            ...state.tenseForms.map(
              (e) => _buildTableCell(e.negative, e.negativeExample),
            ),
          ]),
          TableRow(children: [
            _buildFistCell(
                AppLocalizations.of(context)!.question, context, isDarkTheme),
            ...state.tenseForms.map(
              (e) => _buildTableCell(e.question, e.questionExample),
            ),
          ]),
        ],
      ),
    );
  }
}

Widget _buildTableCell(String structure, String example) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            structure,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(example,
              style: const TextStyle(
                fontSize: 16,
              )),
        ],
      ),
    ),
  );
}

Widget _buildFistCell(String text, BuildContext context, isDarkTheme) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? Colors.white : Theme.of(context).primaryColor,
        ),
      ),
    ),
  );
}

Widget _buildHeaderText(String text) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  );
}
