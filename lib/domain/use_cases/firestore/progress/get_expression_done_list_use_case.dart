import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetExpressionDoneListUseCase implements FutureOutputUseCase<List<int>> {
  @override
  Future<List<int>> run() {
    return injector.get<FirestoreRepository>().getExpressionDoneList();
  }
}
