import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetCurrentUserUseCase implements OutputUseCase<User> {
  @override
  User run() {
    return injector.get<AuthenticationRepository>().getCurrentUser();
  }
}
