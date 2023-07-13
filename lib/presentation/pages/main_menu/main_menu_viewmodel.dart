import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_topic_list_from_category_use_case.dart';

import 'main_menu_state.dart';

class MainMenuViewModel extends StateNotifier<MainMenuState> {
  final GetTopicListFromCategoryUseCase _getTopicListFromCategoryUseCase;
  MainMenuViewModel(this._getTopicListFromCategoryUseCase)
      : super(const MainMenuState(currentTabIndex: 0));

  void changeTab(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}
