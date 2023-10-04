import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class CreateUserWithEmailAndPasswordUseCase
    implements FutureUseCase<CreateUserWithEmailParams, UserCredential> {
  CreateUserWithEmailAndPasswordUseCase();

  @override
  Future<UserCredential> run(CreateUserWithEmailParams input) async {
    return await injector
        .get<AuthenticationRepository>()
        .createUserWithEmailAndPassword(input.email, input.password);
  }
}

class CreateUserWithEmailParams {
  final String email;
  final String password;

  CreateUserWithEmailParams({required this.email, required this.password});
}
