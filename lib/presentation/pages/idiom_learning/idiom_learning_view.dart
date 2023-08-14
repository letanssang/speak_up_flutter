import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_idiom_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/definition_card/definition_card.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final idiomLearningViewModelProvider = StateNotifierProvider.autoDispose<
    IdiomLearningViewModel, IdiomLearningState>(
  (ref) => IdiomLearningViewModel(
    injector.get<GetSentenceListFromIdiomUseCase>(),
    injector.get<PlayAudioFromUrlUseCase>(),
  ),
);

class IdiomLearningView extends ConsumerStatefulWidget {
  const IdiomLearningView({super.key});

  @override
  ConsumerState<IdiomLearningView> createState() => _IdiomLearningViewState();
}

class _IdiomLearningViewState extends ConsumerState<IdiomLearningView> {
  Idiom idiom = Idiom.initial();
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    idiom = ModalRoute.of(context)!.settings.arguments as Idiom;
    await ref.read(idiomLearningViewModelProvider.notifier).setIdiom(idiom);
    ref
        .read(idiomLearningViewModelProvider.notifier)
        .playAudio(idiom.audioEndpoint);
    await ref
        .read(idiomLearningViewModelProvider.notifier)
        .fetchExampleSentences();
    ref.read(idiomLearningViewModelProvider.notifier).updateTotalPage();
  }

  void nextPage() {
    if (_pageController.page!.toInt() ==
        ref.watch(idiomLearningViewModelProvider
                .select((value) => value.totalPage)) -
            1) {
      ref
          .read(idiomLearningViewModelProvider.notifier)
          .updateCurrentPage(_pageController.page!.toInt() + 1);
      Future.delayed(const Duration(milliseconds: 1000), () {
        showExitBottomSheet();
      });
    } else {
      ref
          .read(idiomLearningViewModelProvider.notifier)
          .updateCurrentPage(_pageController.page!.toInt() + 1);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void showExitBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().setHeight(300),
            padding: EdgeInsets.all(ScreenUtil().setWidth(32)),
            child: Column(children: [
              Text(AppLocalizations.of(context)!.areYouSure,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: ScreenUtil().setHeight(16),
              ),
              CustomButton(
                  text: AppLocalizations.of(context)!.exit,
                  fontWeight: FontWeight.bold,
                  textSize: ScreenUtil().setSp(16),
                  marginVertical: ScreenUtil().setHeight(16),
                  onTap: () {
                    Navigator.of(context).pop();
                    ref.read(appNavigatorProvider).pop();
                  }),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold),
                  )),
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomLearningViewModelProvider);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: showExitBottomSheet,
            icon: const Icon(
              Icons.close_outlined,
            ),
          ),
          title: AppLinearPercentIndicator(
            percent: state.currentPage / state.totalPage,
          )),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildDefinitionIdiom(state, context),
          if (state.loadingStatus == LoadingStatus.success)
            ...state.exampleSentences.map(
              (sentence) => Container(
                child: Column(
                  children: [
                    Text(
                      sentence.text,
                    ),
                    CustomButton(
                      text: AppLocalizations.of(context)!.next,
                      onTap: nextPage,
                      fontWeight: FontWeight.bold,
                      textSize: ScreenUtil().setSp(18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Center buildDefinitionIdiom(IdiomLearningState state, BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(32),
          ),
          DefinitionCard(
            name: state.idiom.name,
            description: state.idiom.description,
            descriptionTranslation: state.idiom.descriptionTranslation,
            tapFrontDescription:
                AppLocalizations.of(context)!.tapToSeeTheMeaning,
            tapBackDescription: AppLocalizations.of(context)!.tapToSeeTheIdiom,
            onPressed: () => ref
                .read(idiomLearningViewModelProvider.notifier)
                .playAudio(state.idiom.audioEndpoint),
          ),
          Flexible(child: Container()),
          CustomButton(
            text: AppLocalizations.of(context)!.next,
            onTap: nextPage,
            fontWeight: FontWeight.bold,
            textSize: ScreenUtil().setSp(18),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(32),
          ),
        ],
      ),
    );
  }
}
