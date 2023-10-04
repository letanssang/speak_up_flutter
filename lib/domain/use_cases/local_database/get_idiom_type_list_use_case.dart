import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetIdiomTypeListUseCase implements FutureOutputUseCase<List<IdiomType>> {
  @override
  Future<List<IdiomType>> run() {
    return injector.get<LocalDatabaseRepository>().getIdiomTypeList();
  }
}
