import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetSentencePatternListUseCase
    implements FutureOutputUseCase<List<SentencePattern>> {
  @override
  Future<List<SentencePattern>> run() {
    return injector.get<LocalDatabaseRepository>().getSentencePatternList();
  }
}
