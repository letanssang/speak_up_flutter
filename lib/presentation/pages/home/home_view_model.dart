import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/firestore/get_youtube_playlist_id_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_category_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_lesson_list_use_case.dart';
import 'package:speak_up/domain/use_cases/youtube/get_youtube_playlist_by_id_use_case.dart';
import 'package:speak_up/presentation/pages/home/home_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final GetLessonListUseCase _getLessonListUseCase;
  final GetCategoryListUseCase _getCategoryListUseCase;
  final GetYoutubePLayListIdListUseCase _getYoutubePLayListIdListUseCase;
  final GetYoutubePlaylistByIdUseCase _getYoutubePlaylistByIdUseCase;

  HomeViewModel(
    this._getLessonListUseCase,
    this._getCategoryListUseCase,
    this._getYoutubePLayListIdListUseCase,
    this._getYoutubePlaylistByIdUseCase,
  ) : super(const HomeState());

  Future<void> getLessonList() async {
    if (!mounted) return;

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
    if (!mounted) return;
    state = state.copyWith(categoriesLoadingStatus: LoadingStatus.loading);
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

  Future<void> getYoutubeVideoLists() async {
    if (!mounted) return;
    state = state.copyWith(
      youtubeVideoListsLoadingStatus: LoadingStatus.loading,
    );
    try {
      final idList = await _getYoutubePLayListIdListUseCase.run();
      final youtubeVideoLists = await Future.wait(
        idList.map((e) => _getYoutubePlaylistByIdUseCase.run(e)),
      );
      state = state.copyWith(
        youtubeVideoListsLoadingStatus: LoadingStatus.success,
        youtubeVideoLists: youtubeVideoLists,
      );
    } catch (e) {
      state = state.copyWith(
        youtubeVideoListsLoadingStatus: LoadingStatus.error,
      );
      rethrow;
    }
  }
}
