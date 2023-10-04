import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class UpdateDisplayNameUseCase implements FutureUseCase<String, void> {
  @override
  Future<void> run(String input) async {
    final authRepository = injector.get<AuthenticationRepository>();
    await authRepository.updateDisplayName(input);
    await injector
        .get<FirestoreRepository>()
        .updateDisplayName(input, authRepository.getCurrentUser().uid);
  }
}
