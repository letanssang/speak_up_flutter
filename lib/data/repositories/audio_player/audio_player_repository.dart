import 'package:audioplayers/audioplayers.dart';

class AudioPlayerRepository {
  final AudioPlayer _audioPlayer;
  AudioPlayerRepository(this._audioPlayer);
  Future<void> playAudioFromUrl(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }
}
