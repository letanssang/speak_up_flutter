import 'package:record/record.dart';

class RecordRepository {
  final Record _record;
  RecordRepository(this._record);
  Future<void> start() async {
    await _record.start();
  }

  Future<void> stop() async {
    await _record.stop();
  }
}
