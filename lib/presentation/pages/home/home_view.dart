import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/data/providers/lesson_list_provider.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/constant/categories.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  List<Lesson> lessons = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    lessons = await ref.read(lessonListProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    return SingleChildScrollView(
      child: SizedBox(
        height: ScreenUtil().screenHeight * 1.5,
        width: ScreenUtil().screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().statusBarHeight,
            ),
            buildAppBar(context),
            buildCurrentCourses(),
            buildCategories(ref.watch(themeProvider), context, () {
              ref.read(appNavigatorProvider).navigateTo(AppRoutes.categories);
            }, ref),
            buildExplore(context, isDarkTheme),
          ],
        ),
      ),
    );
  }

  Expanded buildExplore(BuildContext context, bool isDarkTheme) {
    return Expanded(
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
                  'Explore',
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
                      .navigateTo(AppRoutes.lessons, arguments: lessons);
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              buildExploreItem(lessons.isNotEmpty ? lessons[0].name : '',
                  isDarkTheme, lessons.isNotEmpty ? lessons[0].imageURL : null),
              buildExploreItem(lessons.isNotEmpty ? lessons[1].name : '',
                  isDarkTheme, lessons.isNotEmpty ? lessons[1].imageURL : null),
            ],
          )
        ],
      ),
    );
  }

  Widget buildExploreItem(String title, bool isDarkTheme, String? imageURL) {
    return SizedBox(
      width: ScreenUtil().screenWidth * 0.45,
      height: ScreenUtil().screenHeight * 0.36,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: isDarkTheme ? Colors.grey[800] : Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                          image: imageURL != null
                              ? NetworkImage(imageURL)
                              : const AssetImage(
                                  'assets/images/temp_topic.png',
                                ) as ImageProvider),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildAppBar(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: 20,
            child: ClipOval(
              child: user.photoURL != null
                  ? Image.network(user.photoURL!)
                  : AppImages.avatar(),
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
              child: Text('Continue learning',
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

  Flexible buildCategories(bool isDarkTheme, BuildContext context,
      Function()? onPressed, WidgetRef ref) {
    final icons = isDarkTheme ? categoryDarkIcons : categoryIcons;
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
                    'Categories',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onPressed,
                  child: Text(
                    'View all',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        List<Widget>.generate(categories.length - 3, (index) {
                      if (index % 2 == 0) {
                        // Chỉ số chẵn
                        return buildCategoryItem(icons[index],
                            categories[index].name, isDarkTheme, index, ref);
                      } else {
                        // Chỉ số lẻ
                        return const SizedBox();
                      }
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List<Widget>.generate(categories.length, (index) {
                      if (index % 2 != 0) {
                        // Chỉ số lẻ
                        return buildCategoryItem(icons[index],
                            categories[index].name, isDarkTheme, index, ref);
                      } else {
                        // Chỉ số chẵn
                        return const SizedBox();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(
      Widget icon, String title, bool isDarkTheme, int index, WidgetRef ref) {
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
              .navigateTo(AppRoutes.category, arguments: index);
        },
        child: Row(
          children: [
            icon,
            SizedBox(
              width: ScreenUtil().setWidth(3),
            ),
            Text(
              title,
              style:
                  TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
