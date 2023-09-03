import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:speak_up/data/models/dictionary/dictionary_search_response.dart';
import 'package:speak_up/data/models/dictionary/word_detail_response.dart';

part 'dictionary_client.g.dart';

@RestApi(baseUrl: 'https://wordsapiv1.p.rapidapi.com/')
abstract class DictionaryClient {
  factory DictionaryClient(Dio dio, {String baseUrl}) = _DictionaryClient;

  @GET('/words/{word}')
  Future<WordDetailResponse> getWordDetail(
    @Path('word') String word,
  );

  @GET(
      '/words/?letterPattern={letterPattern}&limit={limit}&page={page}&frequencymin={frequencymin}&hasDetails={hasDetails}')
  Future<DictionarySearchResponse> searchWord(
    @Path('letterPattern') String letterPattern,
    @Path('frequencymin') double frequencymin,
    @Path('hasDetails') String hasDetails,
    @Path('limit') int limit,
    @Path('page') int page,
  );
}
