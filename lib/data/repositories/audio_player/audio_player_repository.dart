import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerRepository {
  final AudioPlayer _audioPlayer;
  final AudioPlayer _slowAudioPlayer;

  AudioPlayerRepository(this._audioPlayer, this._slowAudioPlayer);

  Future<void> playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> playAudioFromAsset(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> playAudioFromFile(String path) async {
    try {
      await _audioPlayer.play(DeviceFileSource(path));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> pauseAudio() async {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
    }
  }

  Future<void> stopAudio() async {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.stop();
    }
  }
}
