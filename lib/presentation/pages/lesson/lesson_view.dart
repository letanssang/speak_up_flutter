import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';
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
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: ScreenUtil().screenWidth * 9 / 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(lesson.imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(ScreenUtil().setHeight(8)),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(3)),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: ScreenUtil().setHeight(20),
                          color: Colors.black,
                        ),
                        onPressed: Navigator.of(context).pop,
                      ),
                    ),
                    Flexible(child: Container()),
                    Container(
                      width: ScreenUtil().screenWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Text(
                          language == Language.english
                              ? lesson.name
                              : lesson.translation,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
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
                  lessonWidgetList[lesson.lessonID],
                ],
              ),
            ),
          ],
        ),
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
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
          ),
        ),
      ),
    );
  }
}
