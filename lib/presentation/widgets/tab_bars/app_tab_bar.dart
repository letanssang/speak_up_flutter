import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[350]),
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
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(
            icon: Text(
              titleTab1,
            ),
          ),
          Tab(
            icon: Text(titleTab2),
          ),
        ],
      ),
    );
  }
}
