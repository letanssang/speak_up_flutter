import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetIdiomListByTypeUseCase implements FutureUseCase<int, List<Idiom>> {
  @override
  Future<List<Idiom>> run(int input) {
    return injector.get<LocalDatabaseRepository>().getIdiomListByType(input);
  }
}
