import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/home/home_view.dart';
import 'package:speak_up/presentation/pages/profile/profile_view.dart';
import 'package:speak_up/presentation/pages/search/search_view.dart';

import 'main_menu_state.dart';
import 'main_menu_viewmodel.dart';

final mainMenuViewModelProvider =
    StateNotifierProvider.autoDispose<MainMenuViewModel, MainMenuState>(
  (ref) => MainMenuViewModel(
    injector.get<GetTopicListFromCategoryUseCase>(),
  ),
);
List<Widget> _pageOptions = <Widget>[
  const HomeView(),
  const SearchView(),
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
          currentIndex: state.currentTabIndex,
          onTap: (index) {
            ref.read(mainMenuViewModelProvider.notifier).changeTab(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ));
  }
}
