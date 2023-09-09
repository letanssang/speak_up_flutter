import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPhrasalVerbTypeListUseCase
    extends FutureOutputUseCase<List<PhrasalVerbType>> {
  @override
  Future<List<PhrasalVerbType>> run() {
    return injector.get<FirestoreRepository>().getPhrasalVerbTypeList();
  }
}
