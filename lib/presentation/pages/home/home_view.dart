import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/utilities/constant/categories.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: SizedBox(
        height: ScreenUtil().screenHeight * 2,
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
            },
              ref
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Explore',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          width: ScreenUtil().screenWidth * 0.4,
                          height: ScreenUtil().screenHeight * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/temp_topic.png',),
                              fit: BoxFit.cover,
                            ),

                          ),
                        );
                      }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildAppBar(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: ScreenUtil().setWidth(20),
            backgroundImage: const AssetImage('assets/images/avatar.png'),
          ),
        ),
        Text(
          'Hi Sang',
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

  Flexible buildCategories(
      bool isDarkTheme, BuildContext context, Function()? onPressed, WidgetRef ref) {
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
                        return buildCategoryItem(
                            icons[index], categories[index].name, isDarkTheme, index, ref);
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
                        return buildCategoryItem(
                            icons[index], categories[index].name, isDarkTheme, index, ref);
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

  Widget buildCategoryItem(Widget icon, String title, bool isDarkTheme, int index, WidgetRef ref) {
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
          ref.read(appNavigatorProvider).navigateTo(AppRoutes.category, arguments: index);
        },
        child: Row(
          children: [
            icon,
            SizedBox(
              width: ScreenUtil().setWidth(3),
            ),
            Text(
              title,
              style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
