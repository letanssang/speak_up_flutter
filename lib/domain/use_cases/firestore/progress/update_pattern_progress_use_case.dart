import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class UpdatePatternProgressUseCase
    implements FutureUseCase<LectureProcess, void> {
  @override
  Future<void> run(LectureProcess input) {
    return injector.get<FirestoreRepository>().updatePatternProgress(input);
  }
}
