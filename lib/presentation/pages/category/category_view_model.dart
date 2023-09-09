import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/presentation/pages/category/category_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class CategoryViewModel extends StateNotifier<CategoryState> {
  final GetTopicListByCategoryIDUseCase _getTopicListFromCategoryUseCase;

  CategoryViewModel(
    this._getTopicListFromCategoryUseCase,
  ) : super(const CategoryState());

  Future<void> fetchTopicList(int categoryID) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final topics = await _getTopicListFromCategoryUseCase.run(categoryID);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        topics: topics,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
