import 'package:record/record.dart';

class RecordRepository {
  final Record _record;

  RecordRepository(this._record);

  Future<void> startRecording() async {
    try {
      final AudioEncoder? encoder;
      // if (Platform.isIOS) {
      //   encoder = AudioEncoder.flac;
      // } else if (Platform.isAndroid) {
      //   encoder = AudioEncoder.wav;
      // } else {
      //   encoder = AudioEncoder.aacLc;
      // }
      encoder = AudioEncoder.wav;
      if (await isPermissionGranted()) {
        await _record.start(
          numChannels: 1,
          encoder: encoder,
          samplingRate: 16000,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> stopRecording() async {
    try {
      return await _record.stop();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isPermissionGranted() async {
    return await _record.hasPermission();
  }
}
