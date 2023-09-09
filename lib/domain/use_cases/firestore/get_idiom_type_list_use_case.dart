import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetIdiomTypeListUseCase extends FutureOutputUseCase<List<IdiomType>> {
  @override
  Future<List<IdiomType>> run() {
    return injector.get<FirestoreRepository>().getIdiomTypeList();
  }
}
