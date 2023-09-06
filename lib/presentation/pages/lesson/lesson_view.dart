import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/presentation/pages/expression_types/expression_types_view.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_view.dart';
import 'package:speak_up/presentation/pages/pattern_lesson_detail/pattern_lesson_detail_view.dart';
import 'package:speak_up/presentation/pages/phrasal_verb_types/phrasal_verb_types_view.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/tab_bars/app_tab_bar.dart';

class LessonView extends ConsumerStatefulWidget {
  const LessonView({super.key});

  @override
  ConsumerState<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends ConsumerState<LessonView>
    with TickerProviderStateMixin {
  Lesson lesson = Lesson.initial();

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  lesson.imageURL,
                  width: ScreenUtil().screenWidth * 0.9,
                  height: ScreenUtil().screenWidth * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Text(lesson.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 16),
            child: Text(lesson.translation,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                )),
          ),
          AppTabBar(
            tabController: _tabController,
            titleTab1: AppLocalizations.of(context)!.about,
            titleTab2: AppLocalizations.of(context)!.lesson,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                buildAboutLesson(language),
                buildDetailLesson(isDarkTheme, lesson.lessonID),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutLesson(Language language) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        child: Text(
          language == Language.english
              ? lesson.description
              : lesson.descriptionTranslation,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildDetailLesson(bool isDarkTheme, int lessonID) {
    switch (lessonID) {
      case 1:
        return const PatternLessonDetailView();
      case 2:
        return const ExpressionTypesView();
      case 3:
        return const PhrasalVerbTypesView();
      case 4:
        return const IdiomTypesView();
      default:
        return Container();
    }
  }
}
