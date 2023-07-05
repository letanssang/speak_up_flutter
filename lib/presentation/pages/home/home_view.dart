import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/constant/categories.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: SizedBox(
        height: ScreenUtil().screenHeight * 1.5,
        width: ScreenUtil().screenWidth,
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                  width: ScreenUtil().screenWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16),
                  ),
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hello, Sang',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Let\'s start learning',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF311A6B),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(32),
                              ),
                              height: ScreenUtil().setHeight(60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: Icon(Icons.search),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(16),
                            ),
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                                onPressed: () {}, icon: AppIcons.filter()),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            buildCategories(ref.watch(themeProvider), context, () {
              ref.read(appNavigatorProvider).navigateTo(AppRoutes.categories);
            }),

            buildCurrentCourses(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: ScreenUtil().screenHeight * 0.15,
                            width: ScreenUtil().screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(8),
                          ),
                          Container(
                            height: ScreenUtil().screenHeight * 0.15,
                            width: ScreenUtil().screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: ScreenUtil().screenHeight * 0.15,
                            width: ScreenUtil().screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(8),
                          ),
                          Container(
                            height: ScreenUtil().screenHeight * 0.15,
                            width: ScreenUtil().screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildCurrentCourses() {
    return Flexible(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Continue learning',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: ScreenUtil().screenHeight * 0.2,
              child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(
                        width: ScreenUtil().setWidth(16),
                      ),
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: ScreenUtil().screenHeight * 0.16,
                      width: ScreenUtil().screenWidth * 0.6,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        borderRadius: BorderRadius.circular(16),
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
      Function()? onPressed) {
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
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
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
                    children: List<Widget>.generate(categories.length, (index) {
                      return buildCategoryItem(
                         categoryIcons[index], categories[index].name, isDarkTheme);
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

  Widget buildCategoryItem(Widget icon, String title, bool isDarkTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black54),
        color: isDarkTheme ? const Color(0xFF605F5F) : Colors.white,
      ),
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
    );
  }
}
