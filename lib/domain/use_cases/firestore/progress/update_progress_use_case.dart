import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/lecture_process/lecture_process.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';

class UpdateProgressUseCase
    implements FutureUseCaseTwoInput<LectureProcess, LessonEnum, void> {
  @override
  Future<void> run(LectureProcess input, LessonEnum lessonEnum) {
    switch (lessonEnum) {
      case LessonEnum.pattern:
        return injector.get<FirestoreRepository>().updatePatternProgress(input);
      case LessonEnum.expression:
        return injector
            .get<FirestoreRepository>()
            .updateExpressionProgress(input);
      case LessonEnum.phrasalVerb:
        return injector
            .get<FirestoreRepository>()
            .updatePhrasalVerbProgress(input);
      case LessonEnum.idiom:
        return injector.get<FirestoreRepository>().updateIdiomProgress(input);
      case LessonEnum.phonetic:
        return injector
            .get<FirestoreRepository>()
            .updatePhoneticProgress(input);
      default:
        {
          throw Exception("LessonEnum is not valid");
        }
    }
  }
}
