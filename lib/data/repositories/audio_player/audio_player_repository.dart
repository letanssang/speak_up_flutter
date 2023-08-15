import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerRepository {
  final AudioPlayer _audioPlayer;

  AudioPlayerRepository(this._audioPlayer);

  Future<void> playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> playAudioFromAsset(String path) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopAudio() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.stop();
    }
  }
}
