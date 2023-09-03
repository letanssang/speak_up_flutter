import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:speak_up/data/models/youtube_video/youtube_playlist_response.dart';

part 'youtube_client.g.dart';

@RestApi(baseUrl: 'https://www.googleapis.com/youtube/v3/')
abstract class YoutubeClient {
  factory YoutubeClient(Dio dio, {String baseUrl}) = _YoutubeClient;

  @GET('playlistItems')
  Future<YoutubePlaylistResponse> getPlaylist(
    @Query('part') String part,
    @Query('playlistId') String playlistId,
    @Query('key') String key,
    @Query('maxResults') int maxResults,
  );
}
