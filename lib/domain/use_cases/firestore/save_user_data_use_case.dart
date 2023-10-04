import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class SaveUserDataUseCase implements FutureUseCase<User, void> {
  @override
  Future<void> run(User input) async {
    injector.get<FirestoreRepository>().saveUserData(input);
  }
}
