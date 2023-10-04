import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/word/word.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetWordListByPhoneticIDUSeCase implements FutureUseCase<int, List<Word>> {
  @override
  Future<List<Word>> run(int input) {
    return injector
        .get<LocalDatabaseRepository>()
        .getWordListByPhoneticID(input);
  }
}
