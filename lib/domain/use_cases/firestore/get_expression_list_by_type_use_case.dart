import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/expression/expression.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetExpressionListByTypeUseCase
    extends FutureUseCase<int, List<Expression>> {
  @override
  Future<List<Expression>> run(int input) {
    return injector.get<FirestoreRepository>().getExpressionListByType(input);
  }
}
