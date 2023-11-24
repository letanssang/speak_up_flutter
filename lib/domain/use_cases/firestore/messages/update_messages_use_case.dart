import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/message/message.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class UpdateMessagesUseCase implements FutureUseCase<List<Message>, void> {
  @override
  Future<void> run(List<Message> messages) async {
    // convert list<messages> to list<map>
    List<Map<String, dynamic>> messagesMap = [];
    for (var message in messages) {
      messagesMap.add(message.toJson());
    }
    String uid = injector.get<AuthenticationRepository>().getCurrentUser().uid;
    return injector.get<FirestoreRepository>().updateMessages(messagesMap, uid);
  }
}
