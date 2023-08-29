import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_category_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_lesson_list_use_case.dart';
import 'package:speak_up/presentation/pages/home/home_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final GetLessonListUseCase _getLessonListUseCase;
  final GetCategoryListUseCase _getCategoryListUseCase;

  HomeViewModel(
    this._getLessonListUseCase,
    this._getCategoryListUseCase,
  ) : super(const HomeState());

  Future<void> getLessonList() async {
    state = state.copyWith(lessonsLoadingStatus: LoadingStatus.loading);
    try {
      final lessons = await _getLessonListUseCase.run();
      state = state.copyWith(
        lessonsLoadingStatus: LoadingStatus.success,
        lessons: lessons,
      );
    } catch (e) {
      state = state.copyWith(lessonsLoadingStatus: LoadingStatus.error);
      rethrow;
    }
  }

  Future<void> getCategoryList() async {
    try {
      final categories = await _getCategoryListUseCase.run();
      state = state.copyWith(
        categoriesLoadingStatus: LoadingStatus.success,
        categories: categories,
      );
    } catch (e) {
      state = state.copyWith(categoriesLoadingStatus: LoadingStatus.error);
      rethrow;
    }
  }
}
