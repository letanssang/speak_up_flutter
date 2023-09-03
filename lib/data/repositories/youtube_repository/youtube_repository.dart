import 'package:speak_up/data/models/youtube_video/youtube_playlist_response.dart';
import 'package:speak_up/data/remote/youtube_client/youtube_client.dart';
import 'package:speak_up/presentation/utilities/constant/number.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';

class YoutubeRepository {
  final YoutubeClient _youtubeClient;
  final String _apiKey;

  YoutubeRepository(this._youtubeClient, this._apiKey);

  Future<YoutubePlaylistResponse> getPlaylist(
    String playlistId,
  ) async {
    return await _youtubeClient.getPlaylist(
      partConst,
      playlistId,
      _apiKey,
      maxResultsConst,
    );
  }
}
