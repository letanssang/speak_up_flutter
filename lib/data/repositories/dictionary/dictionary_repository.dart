import 'package:speak_up/data/models/dictionary/dictionary_search_response.dart';
import 'package:speak_up/data/models/dictionary/word_detail_response.dart';
import 'package:speak_up/data/remote/dictionary_client/dictionary_client.dart';
import 'package:speak_up/presentation/utilities/constant/number.dart';

class DictionaryRepository {
  final DictionaryClient _dictionaryClient;

  DictionaryRepository(this._dictionaryClient);

  Future<WordDetailResponse> getWordDetail(
    String word,
  ) async {
    return await _dictionaryClient.getWordDetail(
      word,
    );
  }

  Future<DictionarySearchResponse> searchWord(
    String letterPattern,
  ) async {
    return await _dictionaryClient.searchWord(
      letterPattern,
      frequencyMin,
      'definitions',
      limit,
      page,
    );
  }
}
