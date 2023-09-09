import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetIdiomListByTypeUseCase extends FutureUseCase<int, List<Idiom>> {
  @override
  Future<List<Idiom>> run(int input) {
    return injector.get<FirestoreRepository>().getIdiomListByType(input);
  }
}
