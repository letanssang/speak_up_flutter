import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class UpdatePasswordUseCase implements FutureUseCase<String, void> {
  @override
  Future<void> run(String input) async {
    injector.get<AuthenticationRepository>().updatePassword(input);
  }
}
