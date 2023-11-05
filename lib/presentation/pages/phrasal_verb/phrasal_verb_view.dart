import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_phrasal_verb_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_state.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_view_model.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view.dart';
import 'package:speak_up/presentation/utilities/common/percent_calculate.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_circular_percent_indicator.dart';

final phrasalVerbViewModelProvider =
    StateNotifierProvider.autoDispose<PhrasalVerbViewModel, PhrasalVerbState>(
  (ref) => PhrasalVerbViewModel(
    injector.get<GetPhrasalVerbListByTypeUseCase>(),
    injector.get<GetPhrasalVerbProgressUseCase>(),
  ),
);

class PhrasalVerbView extends ConsumerStatefulWidget {
  const PhrasalVerbView({super.key});

  @override
  ConsumerState<PhrasalVerbView> createState() => _PhrasalVerbViewState();
}

class _PhrasalVerbViewState extends ConsumerState<PhrasalVerbView> {
  PhrasalVerbType phrasalVerbType = PhrasalVerbType.initial();

  PhrasalVerbViewModel get _viewModel =>
      ref.read(phrasalVerbViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    phrasalVerbType =
        ModalRoute.of(context)!.settings.arguments as PhrasalVerbType;
    await _viewModel.fetchPhrasalVerbList(phrasalVerbType.phrasalVerbTypeID);
    await _viewModel.updateProgressState(phrasalVerbType.phrasalVerbTypeID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phrasalVerbViewModelProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
        ),
        body: state.loadingStatus == LoadingStatus.success
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: buildHeader(state, language),
                  ),
                  SliverAppBar(
                    toolbarHeight: ScreenUtil().setHeight(50),
                    leading: const SizedBox(),
                    pinned: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        state.progress == state.phrasalVerbs.length
                            ? AppLocalizations.of(context)!.completed
                            : '${state.phrasalVerbs.length} ${AppLocalizations.of(context)!.daysCompleted}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    elevation: 0,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index.isEven) {
                        // Add the separator logic for even indexes
                        return buildSeparator(context, state, index);
                      } else {
                        // Content for odd indexes (phrasalVerb items)
                        final phrasalVerbIndex = index ~/ 2;
                        return buildCardItem(state, phrasalVerbIndex);
                      }
                    },
                        // Double the count to include separators
                        childCount: state.phrasalVerbs.length * 2),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                        height:
                            ScreenUtil().setHeight(32)), // Add desired spacing
                  ),
                ],
              )
            : const AppLoadingIndicator());
  }

  Widget buildCardItem(PhrasalVerbState state, int phrasalVerbIndex) {
    final isDarkTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: InkWell(
        onTap: () {
          if (phrasalVerbIndex <= state.progress) {
            ref.read(appNavigatorProvider).navigateTo(
                AppRoutes.pronunciationPractice,
                arguments: PronunciationPracticeViewArguments(
                  parentID: state.phrasalVerbs[phrasalVerbIndex].phrasalVerbID,
                  lessonEnum: LessonEnum.phrasalVerb,
                  progress: state.progress,
                  grandParentID: phrasalVerbType.phrasalVerbTypeID,
                  canUpdateProgress: phrasalVerbIndex == state.progress,
                ));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: state.progress == phrasalVerbIndex
                ? Border.all(
                    color: Colors.grey,
                    width: 2,
                  )
                : null,
            color: state.progress > phrasalVerbIndex
                ? const Color(0XFF6B3D90)
                : state.progress == phrasalVerbIndex
                    ? Theme.of(context).primaryColor
                    : isDarkTheme
                        ? Colors.grey[700]
                        : Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(16),
                  ),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.day} ${phrasalVerbIndex + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (phrasalVerbIndex != state.progress)
                    Icon(
                      phrasalVerbIndex > state.progress
                          ? Icons.lock_outline
                          : Icons.check_circle_outline,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(16),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.phrasalVerbs[phrasalVerbIndex].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildSeparator(BuildContext context, PhrasalVerbState state, int index) {
    return Row(
      children: [
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 3,
          ),
          width: 2,
          height: 32,
          color: index ~/ 2 < state.progress + 1
              ? Theme.of(context).primaryColor
              : Colors.grey, // Black color
        ),
        const Spacer(),
      ],
    );
  }

  Padding buildHeader(PhrasalVerbState state, Language language) {
    final percent = percentCalculate(state.progress, state.phrasalVerbs.length);
    return Padding(
      padding: EdgeInsets.all(
        ScreenUtil().setWidth(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  language == Language.english
                      ? phrasalVerbType.name
                      : phrasalVerbType.translation,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppCircularPercentIndicator(
                title: '${percent.toStringAsFixed(0)}%',
                percent: percent / 100,
                radius: ScreenUtil().setWidth(32),
                lineWidth: ScreenUtil().setWidth(8),
                titleSize: ScreenUtil().setSp(14),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
