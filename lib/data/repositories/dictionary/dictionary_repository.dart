import 'package:speak_up/data/models/dictionary_search_response.dart';
import 'package:speak_up/data/remote/dictionary_client/dictionary_client.dart';

class DictionaryRepository {
  final DictionaryClient _dictionaryClient;
  DictionaryRepository(this._dictionaryClient);

  Future<DictionarySearchResponse> searchWord(
    String letterPattern,
  ) async {
    return await _dictionaryClient.searchWord(
      letterPattern,
      10,
      1,
    );
  }
}
