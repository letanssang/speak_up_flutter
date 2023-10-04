import 'package:speak_up/data/repositories/record/record_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class StartRecordingUseCase implements FutureOutputUseCase<void> {
  @override
  Future<void> run() {
    return injector.get<RecordRepository>().startRecording();
  }
}
