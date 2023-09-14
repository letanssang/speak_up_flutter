import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/tab_bars/app_tab_bar.dart';

class SavedView extends ConsumerStatefulWidget {
  const SavedView({super.key});

  @override
  ConsumerState<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends ConsumerState<SavedView>
    with TickerProviderStateMixin {
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
    return Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
            },
          ),
        ),
        body: Column(
          children: [
            AppTabBar(
              tabController: _tabController,
              titleTab1: 'Saved',
              titleTab2: 'Flashcards',
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  buildEmptyBody(),
                  buildEmptyBody(),
                ],
              ),
            ),
          ],
        ));
  }

  Center buildEmptyBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImages.noData(
            width: ScreenUtil().screenWidth * 0.5,
            height: ScreenUtil().screenWidth * 0.5,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Nothing here',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
              'We found nothing in your saved list!\n Let\'s explore and save something.',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: Colors.grey[600],
              )),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
            },
            child: const Text('Explore'),
          )
        ],
      ),
    );
  }
}
