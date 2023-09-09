import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetCategoryListUseCase extends FutureOutputUseCase<List<Category>> {
  @override
  Future<List<Category>> run() {
    return injector.get<FirestoreRepository>().getCategoryList();
  }
}
