import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/entities/youtube_video/youtube_video.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<Lesson> lessons,
    @Default([]) List<Category> categories,
    @Default([]) List<FlashCard> flashCards,
    @Default([]) List<List<YoutubeVideo>> youtubeVideoLists,
    @Default(LoadingStatus.initial) LoadingStatus lessonsLoadingStatus,
    @Default(LoadingStatus.initial) LoadingStatus categoriesLoadingStatus,
    @Default(LoadingStatus.initial) LoadingStatus flashCardsLoadingStatus,
    @Default(LoadingStatus.initial)
    LoadingStatus youtubeVideoListsLoadingStatus,
  }) = _HomeState;
}
