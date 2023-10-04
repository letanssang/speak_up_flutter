import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/tense/tense.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetTenseListUseCase implements FutureOutputUseCase<List<Tense>> {
  @override
  Future<List<Tense>> run() {
    return injector.get<LocalDatabaseRepository>().getTenseList();
  }
}
