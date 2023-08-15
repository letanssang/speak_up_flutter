import 'package:record/record.dart';

class RecordRepository {
  final Record _record;
  RecordRepository(this._record);
  Future<void> startRecording() async {
    try {
      if (await isPermissionGranted()) {
        await _record.start();
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
