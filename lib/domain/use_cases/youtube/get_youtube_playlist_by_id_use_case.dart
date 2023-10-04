import 'package:speak_up/data/repositories/youtube_repository/youtube_repository.dart';
import 'package:speak_up/domain/entities/youtube_video/youtube_video.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetYoutubePlaylistByIdUseCase
    implements FutureUseCase<String, List<YoutubeVideo>> {
  @override
  Future<List<YoutubeVideo>> run(String input) async {
    final youtubePlaylistResponse =
        await injector.get<YoutubeRepository>().getPlaylist(input);
    return youtubePlaylistResponse.items!.map((e) => e.snippet!).toList();
  }
}
