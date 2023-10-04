import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/tense_usage/tense_usage.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetTenseUsageListFromTenseUseCase
    implements FutureUseCase<int, List<TenseUsage>> {
  @override
  Future<List<TenseUsage>> run(int input) {
    return injector
        .get<LocalDatabaseRepository>()
        .getTenseUsageListFromTense(input);
  }
}
