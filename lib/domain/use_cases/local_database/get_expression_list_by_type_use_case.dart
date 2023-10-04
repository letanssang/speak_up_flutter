import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetExpressionListByTypeUseCase
    implements FutureUseCase<int, List<Expression>> {
  @override
  Future<List<Expression>> run(int input) {
    return injector
        .get<LocalDatabaseRepository>()
        .getExpressionListByType(input);
  }
}
