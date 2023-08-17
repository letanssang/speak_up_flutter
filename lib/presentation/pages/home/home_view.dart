import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_category_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_lesson_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/home/home_state.dart';
import 'package:speak_up/presentation/pages/home/home_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/constant/category_icon_list.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) =>
        HomeViewModel(injector.get<GetLessonListUseCase>(),
            injector.get<GetCategoryListUseCase>()));

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final int _randomIndex1 = Random().nextInt(2);
  final int _randomIndex2 = Random().nextInt(2) + 2;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    await ref.read(homeViewModelProvider.notifier).getCategoryList();
    await ref.read(homeViewModelProvider.notifier).getLessonList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    return SingleChildScrollView(
      child: SizedBox(
        height: ScreenUtil().screenHeight * 1.5,
        width: ScreenUtil().screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().statusBarHeight,
            ),
            buildAppBar(),
            buildCurrentCourses(),
            buildCategories(state),
            buildExplore(state),
          ],
        ),
      ),
    );
  }

  Widget buildExplore(HomeState state) {
    return Flexible(
      flex: 3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Text(
                  AppLocalizations.of(context)!.explore,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(appNavigatorProvider)
                      .navigateTo(AppRoutes.lessons, arguments: state.lessons);
                },
                child: Text(
                  AppLocalizations.of(context)!.viewAll,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: state.lessonsLoadingStatus == LoadingStatus.success
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildExploreItem(state.lessons[_randomIndex1]),
                      buildExploreItem(state.lessons[_randomIndex2]),
                    ],
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget buildExploreItem(Lesson lesson) {
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: ScreenUtil().screenHeight < 800
            ? ScreenUtil().screenHeight * 0.38
            : ScreenUtil().screenHeight * 0.33,
      ),
      child: SizedBox(
        width: ScreenUtil().screenWidth * 0.45,
        child: InkWell(
          onTap: () {
            ref
                .read(appNavigatorProvider)
                .navigateTo(AppRoutes.lesson, arguments: lesson);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isDarkTheme ? Colors.grey[800] : Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(lesson.imageURL)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                    child: Center(
                      child: Text(
                        language == Language.english
                            ? lesson.name
                            : lesson.translation,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildAppBar() {
    final user = FirebaseAuth.instance.currentUser!;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              ref.read(appNavigatorProvider).navigateTo(
                    AppRoutes.editProfile,
                  );
            },
            child: CircleAvatar(
              radius: 20,
              child: ClipOval(
                child: user.photoURL != null
                    ? Image.network(user.photoURL!)
                    : AppImages.avatar(),
              ),
            ),
          ),
        ),
        Text(
          'Hi ${user.displayName}',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications_outlined,
                color: Theme.of(context).iconTheme.color),
          ),
        )
      ],
    );
  }

  Flexible buildCurrentCourses() {
    return Flexible(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(AppLocalizations.of(context)!.continueLearning,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: ScreenUtil().screenHeight * 0.2,
              child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: ScreenUtil().screenHeight * 0.16,
                      width: ScreenUtil().screenWidth * 0.6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/temp_topic.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildCategories(HomeState state) {
    final categories = state.categories;
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    AppLocalizations.of(context)!.categories,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(appNavigatorProvider).navigateTo(
                        AppRoutes.categories,
                        arguments: categories);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            state.categoriesLoadingStatus == LoadingStatus.success
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List<Widget>.generate(categories.length - 1,
                              (index) {
                            if (index % 2 == 0) {
                              return buildCategoryItem(
                                  categories[index], index);
                            } else {
                              return const SizedBox();
                            }
                          }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              List<Widget>.generate(categories.length, (index) {
                            if (index % 2 != 0 ||
                                index == categories.length - 1) {
                              return buildCategoryItem(
                                  categories[index], index);
                            } else {
                              return const SizedBox();
                            }
                          }),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(Category category, int index) {
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black54),
        color: isDarkTheme ? const Color(0xFF605F5F) : Colors.white,
      ),
      child: InkWell(
        onTap: () {
          ref
              .read(appNavigatorProvider)
              .navigateTo(AppRoutes.category, arguments: category);
        },
        child: Row(
          children: [
            isDarkTheme ? categoryDarkIcons[index] : categoryIcons[index],
            SizedBox(
              width: ScreenUtil().setWidth(3),
            ),
            Text(
              language == Language.english
                  ? category.name
                  : category.translation,
              style:
                  TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
