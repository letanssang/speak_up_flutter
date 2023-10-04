import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetTopicListByCategoryIDUseCase
    implements FutureUseCase<int, List<Topic>> {
  @override
  Future<List<Topic>> run(int input) async {
    return injector
        .get<LocalDatabaseRepository>()
        .getTopicListByCategoryID(input);
  }
}
