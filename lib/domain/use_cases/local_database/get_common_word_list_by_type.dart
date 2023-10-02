import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/common_word/common_word.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetCommonWordListByTypeUseCase
    implements FutureUseCase<int, List<CommonWord>> {
  @override
  Future<List<CommonWord>> run(int input) {
    return injector
        .get<LocalDatabaseRepository>()
        .getCommonWordListByType(input);
  }
}
