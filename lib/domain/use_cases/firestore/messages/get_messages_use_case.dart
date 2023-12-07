import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/entities/message/message.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetMessagesUseCase implements FutureOutputUseCase<List<Message>> {
  @override
  Future<List<Message>> run() async {
    String uid = injector.get<AuthenticationRepository>().getCurrentUser().uid;
    List<Map<String, dynamic>> messagesMap =
        await injector.get<FirestoreRepository>().getMessages(uid);
    List<Message> messages = [];
    for (var messageMap in messagesMap) {
      messages.add(Message.fromJson(messageMap));
    }
    return messages;
  }
}
