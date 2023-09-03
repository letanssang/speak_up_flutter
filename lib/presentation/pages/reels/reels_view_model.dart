import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/youtube/get_youtube_playlist_by_id_use_case.dart';
import 'package:speak_up/presentation/pages/reels/reels_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ReelsViewModel extends StateNotifier<ReelsState> {
  final GetYoutubePlaylistByIdUseCase _getYoutubePlaylistByIdUseCase;

  ReelsViewModel(this._getYoutubePlaylistByIdUseCase)
      : super(const ReelsState());

  Future<void> getYoutubePlaylistById(String playlistId) async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    try {
      final youtubeVideos =
          await _getYoutubePlaylistByIdUseCase.run(playlistId);
      state = state.copyWith(
        loadingStatus: LoadingStatus.success,
        youtubeVideos: youtubeVideos,
      );
    } catch (e) {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }
}
