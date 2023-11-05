import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';

class AppTabBar extends ConsumerWidget {
  final TabController tabController;
  final String titleTab1;
  final String titleTab2;

  const AppTabBar({
    super.key,
    required this.tabController,
    required this.titleTab1,
    required this.titleTab2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Container(
      height: ScreenUtil().setHeight(50),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkTheme ? Colors.grey[800] : Colors.grey[350]),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.zero,
        indicatorColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: isDarkTheme ? Colors.white : Colors.black,
        tabs: [
          Tab(
            icon: Text(
              titleTab1,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
              ),
            ),
          ),
          Tab(
            icon: Text(
              titleTab2,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
