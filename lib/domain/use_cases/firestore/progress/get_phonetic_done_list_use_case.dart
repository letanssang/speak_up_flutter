import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPhoneticDoneListUseCase extends FutureOutputUseCase<List<int>> {
  @override
  Future<List<int>> run() {
    String uid = injector.get<AuthenticationRepository>().getCurrentUser().uid;
    return injector.get<FirestoreRepository>().getPhoneticDoneList(uid);
  }
}
