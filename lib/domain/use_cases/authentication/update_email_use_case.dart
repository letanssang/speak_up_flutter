import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class UpdateEmailUseCase extends FutureUseCase<String, void> {
  @override
  Future<void> run(String input) async {
    final authRepository = injector.get<AuthenticationRepository>();
    await authRepository.updateEmail(input);
    await injector
        .get<FirestoreRepository>()
        .updateEmail(input, authRepository.getCurrentUser().uid);
  }
}