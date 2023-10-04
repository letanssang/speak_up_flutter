import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class SignOutUseCase implements OutputUseCase<void> {
  SignOutUseCase();

  @override
  Future<void> run() async {
    await injector.get<AuthenticationRepository>().signOut();
  }
}
