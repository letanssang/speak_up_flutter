import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/pages/home/home_view.dart';
import 'package:speak_up/presentation/pages/ipa/ipa_view.dart';
import 'package:speak_up/presentation/pages/profile/profile_view.dart';
import 'package:speak_up/presentation/pages/saved/saved_view.dart';

import 'main_menu_state.dart';
import 'main_menu_view_model.dart';

final mainMenuViewModelProvider =
    StateNotifierProvider.autoDispose<MainMenuViewModel, MainMenuState>(
  (ref) => MainMenuViewModel(),
);
List<Widget> _pageOptions = <Widget>[
  const HomeView(),
  const IpaView(),
  const SavedView(),
  const ProfileView()
];

class MainMenuView extends ConsumerWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainMenuViewModelProvider);
    return Scaffold(
        body: _pageOptions[state.currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: state.currentTabIndex,
          onTap: (index) {
            ref.read(mainMenuViewModelProvider.notifier).changeTab(index);
          },
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: ScreenUtil().setHeight(24),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.record_voice_over,
                size: ScreenUtil().setHeight(24),
              ),
              label: 'Phonetic.',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
                size: ScreenUtil().setHeight(24),
              ),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: ScreenUtil().setHeight(24),
              ),
              label: 'Profile',
            ),
          ],
        ));
  }
}
