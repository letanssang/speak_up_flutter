import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/injection/injector.dart';

class CreateUserWithEmailAndPasswordUseCase {
  CreateUserWithEmailAndPasswordUseCase();

  Future<void> run({required String email, required String password}) async {
    return await injector
        .get<AuthenticationRepository>()
        .createUserWithEmailAndPassword(email, password);
  }
}
