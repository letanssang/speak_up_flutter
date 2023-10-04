import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/phrasal_verb/phrasal_verb.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPhrasalVerbListByTypeUseCase
    implements FutureUseCase<int, List<PhrasalVerb>> {
  @override
  Future<List<PhrasalVerb>> run(int input) {
    return injector
        .get<LocalDatabaseRepository>()
        .getPhrasalVerbListByType(input);
  }
}
