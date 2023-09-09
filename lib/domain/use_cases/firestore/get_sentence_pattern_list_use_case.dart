import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetSentencePatternListUseCase
    extends FutureOutputUseCase<List<SentencePattern>> {
  @override
  Future<List<SentencePattern>> run() {
    return injector.get<FirestoreRepository>().getSentencePatternList();
  }
}
