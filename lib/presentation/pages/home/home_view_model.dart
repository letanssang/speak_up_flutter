import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
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

  Future<void> init() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    try {
      final lessons = await getLessonList();
      final categories = await getCategoryList();
      state = state.copyWith(
          lessons: lessons,
          categories: categories,
          loadingStatus: LoadingStatus.success);
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  Future<List<Lesson>> getLessonList() async {
    try {
      final lessons = await _getLessonListUseCase.run();
      return lessons;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Category>> getCategoryList() async {
    try {
      final categories = await _getCategoryListUseCase.run();
      return categories;
    } catch (e) {
      rethrow;
    }
  }
}
