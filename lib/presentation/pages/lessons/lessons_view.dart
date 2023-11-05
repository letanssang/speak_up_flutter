import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';

class LessonsView extends ConsumerStatefulWidget {
  const LessonsView({super.key});

  @override
  ConsumerState<LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends ConsumerState<LessonsView> {
  List<Lesson> lessons = [];

  @override
  Widget build(BuildContext context) {
    lessons = ModalRoute.of(context)!.settings.arguments as List<Lesson>;
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
          AppLocalizations.of(context)!.featuredCourses,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.lesson,
                      arguments: lessons[index],
                    );
              },
              child: _buildLessonItem(isDarkTheme, index, language),
            ),
          );
        },
      ),
    );
  }

  Card _buildLessonItem(bool isDarkTheme, int index, Language language) {
    return Card(
      elevation: 5,
      color: isDarkTheme ? Colors.grey[850] : Colors.white,
      surfaceTintColor: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                lessons[index].imageURL,
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(100),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language == Language.english
                        ? lessons[index].name
                        : lessons[index].translation,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
