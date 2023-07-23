import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetSentenceListFromTopicUseCase
    extends FutureUseCase<int, List<Sentence>> {
  @override
  Future<List<Sentence>> run(int input) async {
    return injector.get<FirestoreRepository>().getSentencesFromTopic(input);
  }
}