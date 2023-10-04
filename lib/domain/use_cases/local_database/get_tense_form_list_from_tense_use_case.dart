import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/tense_form/tense_form.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetTenseFormListFromTenseUseCase
    implements FutureUseCase<int, List<TenseForm>> {
  @override
  Future<List<TenseForm>> run(int input) {
    return injector
        .get<LocalDatabaseRepository>()
        .getTenseFormListFromTense(input);
  }
}
