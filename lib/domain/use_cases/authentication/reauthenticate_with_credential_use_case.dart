import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class ReAuthenticateWithCredentialUseCase
    implements FutureUseCase<String, void> {
  @override
  Future<void> run(String input) {
    return injector
        .get<AuthenticationRepository>()
        .reAuthenticateWithCredential(input);
  }
}
