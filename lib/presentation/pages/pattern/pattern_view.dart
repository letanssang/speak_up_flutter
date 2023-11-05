import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_by_parent_id_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_state.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_view_model.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

final patternViewModelProvider =
    StateNotifierProvider.autoDispose<PatternViewModel, PatternState>(
        (ref) => PatternViewModel(
              injector.get<GetSentenceListByParentIDUseCase>(),
              injector.get<SpeakFromTextUseCase>(),
            ));

class PatternView extends ConsumerStatefulWidget {
  const PatternView({super.key});

  @override
  ConsumerState<PatternView> createState() => _PatternViewState();
}

class _PatternViewState extends ConsumerState<PatternView> {
  YoutubePlayerController? _youtubePlayerController;
  SentencePattern pattern = SentencePattern.initial();

  PatternViewModel get _viewModel =>
      ref.read(patternViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    pattern = ModalRoute.of(context)!.settings.arguments as SentencePattern;
    ref
        .read(patternViewModelProvider.notifier)
        .fetchExampleList(pattern.patternID);
    _youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: pattern.youtubeVideoID ?? '',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
        loop: true,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _youtubePlayerController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternViewModelProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(pattern.name,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          _youtubePlayerController == null
              ? Container(
                  width: ScreenUtil().screenWidth - 16,
                  height: ScreenUtil().screenWidth / 16 * 9,
                  color: Colors.black,
                )
              : YoutubePlayer(controller: _youtubePlayerController!),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 300),
              expansionCallback: (int index, bool isExpanded) {
                _viewModel.toggleDialog();
              },
              expandedHeaderPadding: EdgeInsets.zero,
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.dialogue,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.bold,
                          )),
                    ));
                  },
                  isExpanded: state.isOpenedDialog,
                  body: Container(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                    child: Text(
                      pattern.dialogue,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (!state.isOpenedDialog)
            Row(
              children: [
                Flexible(child: Container()),
                CustomIconButton(
                  height: ScreenUtil().setHeight(40),
                  width: ScreenUtil().setWidth(40),
                  icon: Icon(
                    Icons.volume_up_outlined,
                    size: ScreenUtil().setHeight(18),
                  ),
                  onPressed: () {
                    _viewModel.speak(pattern.name);
                  },
                ),
                CustomIconButton(
                    height: ScreenUtil().setHeight(40),
                    width: ScreenUtil().setWidth(40),
                    icon: Icon(
                      Icons.translate_outlined,
                      size: ScreenUtil().setHeight(18),
                    ),
                    onPressed: _viewModel.toggleTranslate),
                Flexible(child: Container()),
              ],
            ),
          if (!state.isOpenedDialog)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                language == Language.english
                    ? state.isTranslated
                        ? pattern.descriptionTranslation
                        : pattern.description
                    : state.isTranslated
                        ? pattern.description
                        : pattern.descriptionTranslation,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Flexible(child: Container()),
          SafeArea(
            child: CustomButton(
              onTap: () {
                ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.pronunciationPractice,
                      // pass id and lessonType
                      arguments: PronunciationPracticeViewArguments(
                        parentID: pattern.patternID,
                        lessonEnum: LessonEnum.pattern,
                      ),
                      shouldReplace: true,
                    );
              },
              text: AppLocalizations.of(context)!.practiceNow,
            ),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
