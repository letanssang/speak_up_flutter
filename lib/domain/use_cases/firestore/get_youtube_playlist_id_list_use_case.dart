import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetYoutubePLayListIdListUseCase
    implements FutureOutputUseCase<List<String>> {
  @override
  Future<List<String>> run() async {
    return injector.get<FirestoreRepository>().getYoutubePlaylistIDList();
  }
}
