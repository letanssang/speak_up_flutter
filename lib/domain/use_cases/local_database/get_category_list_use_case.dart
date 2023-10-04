import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetCategoryListUseCase implements FutureOutputUseCase<List<Category>> {
  @override
  Future<List<Category>> run() {
    return injector.get<LocalDatabaseRepository>().getCategoryList();
  }
}
