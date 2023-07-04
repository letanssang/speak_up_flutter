import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_menu_state.dart';

class MainMenuViewModel extends StateNotifier<MainMenuState> {
  MainMenuViewModel() : super(const MainMenuState(currentTabIndex: 0));

  void changeTab(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}
