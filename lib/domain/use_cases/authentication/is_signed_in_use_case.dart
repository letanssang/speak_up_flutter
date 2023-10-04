import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class IsSignedInUseCase implements OutputUseCase<bool> {
  @override
  bool run() {
    return injector.get<AuthenticationRepository>().isSignedIn();
  }
}
