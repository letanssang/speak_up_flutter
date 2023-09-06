import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class UpdateIdiomProcessUseCase extends FutureUseCase<LectureProcess, void> {
  @override
  Future<void> run(LectureProcess input) {
    return injector.get<FirestoreRepository>().updateIdiomProcess(input);
  }
}
