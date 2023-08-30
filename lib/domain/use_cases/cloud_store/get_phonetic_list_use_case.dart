import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPhoneticListUseCase extends FutureOutputUseCase<List<Phonetic>> {
  @override
  Future<List<Phonetic>> run() async {
    return await injector.get<FirestoreRepository>().getPhoneticList();
  }
}
