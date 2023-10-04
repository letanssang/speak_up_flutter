import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetLessonListUseCase implements FutureOutputUseCase<List<Lesson>> {
  @override
  Future<List<Lesson>> run() async {
    return injector.get<LocalDatabaseRepository>().getLessonList();
  }
}
