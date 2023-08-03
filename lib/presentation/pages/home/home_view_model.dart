import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_lesson_list_use_case.dart';
import 'package:speak_up/presentation/pages/home/home_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final GetLessonListUseCase _getLessonListUseCase;

  HomeViewModel(
    this._getLessonListUseCase,
  ) : super(const HomeState());

  Future<void> getLessonList() async {
    state = state.copyWith(loadingStatus: LoadingStatus.inProgress);
    try {
      final lessons = await _getLessonListUseCase.run();
      state = state.copyWith(
          lessons: lessons, loadingStatus: LoadingStatus.success);
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
      print(e);
    }
  }
}
