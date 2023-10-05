import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/lesson_enum.dart';

class GetSentenceListByParentIDUseCase
    implements FutureUseCaseTwoInput<int, LessonEnum, List<Sentence>> {
  @override
  Future<List<Sentence>> run(int input, LessonEnum lessonEnum) {
    return injector
        .get<LocalDatabaseRepository>()
        .getSentenceListByParentID(input, lessonEnum);
  }
}
