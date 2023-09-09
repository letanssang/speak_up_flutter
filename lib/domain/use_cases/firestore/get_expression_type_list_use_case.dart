import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetExpressionTypeListUseCase
    extends FutureOutputUseCase<List<ExpressionType>> {
  @override
  Future<List<ExpressionType>> run() async {
    return injector.get<FirestoreRepository>().getExpressionTypeList();
  }
}
