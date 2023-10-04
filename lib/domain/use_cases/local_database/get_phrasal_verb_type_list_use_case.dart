import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPhrasalVerbTypeListUseCase
    implements FutureOutputUseCase<List<PhrasalVerbType>> {
  @override
  Future<List<PhrasalVerbType>> run() {
    return injector.get<LocalDatabaseRepository>().getPhrasalVerbTypeList();
  }
}
