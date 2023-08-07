import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/presentation/pages/lesson/widgets/pattern_lesson_detail/pattern_lesson_detail_view.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

class LessonView extends ConsumerStatefulWidget {
  const LessonView({super.key});

  @override
  ConsumerState<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends ConsumerState<LessonView>
    with TickerProviderStateMixin {
  Lesson? lesson;

  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lesson = ModalRoute.of(context)!.settings.arguments as Lesson;
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lesson?.name ?? 'default',
        ),
      ),
      body: lesson == null
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Image.asset(
                    'assets/images/temp_topic.png',
                    width: double.infinity,
                    height: ScreenUtil().screenHeight * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                      language == Language.english
                          ? lesson!.name
                          : lesson!.translation,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  height: 50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[350]),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.zero,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(
                        icon: Text(
                          'About',
                        ),
                      ),
                      Tab(
                        icon: Text('Topics'),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      buildAboutLesson(language),
                      buildDetailLesson(isDarkTheme, lesson!.lessonID),
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
              ? lesson!.description
              : lesson!.descriptionTranslation,
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
      default:
        return Container();
    }
  }
}
