import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class SignInWithEmailAndPasswordUseCase
    implements FutureUseCase<SignInWithEmailParams, UserCredential> {
  SignInWithEmailAndPasswordUseCase();

  @override
  Future<UserCredential> run(SignInWithEmailParams input) async {
    return await injector
        .get<AuthenticationRepository>()
        .signInWithEmailAndPassword(input.email, input.password);
  }
}

class SignInWithEmailParams {
  final String email;
  final String password;

  SignInWithEmailParams({required this.email, required this.password});
}
