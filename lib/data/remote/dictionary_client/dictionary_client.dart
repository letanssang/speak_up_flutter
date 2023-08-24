import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:speak_up/data/models/dictionary_search_response.dart';

part 'dictionary_client.g.dart';

@RestApi(baseUrl: 'https://wordsapiv1.p.rapidapi.com/')
abstract class DictionaryClient {
  factory DictionaryClient(Dio dio, {String baseUrl}) = _DictionaryClient;
  @GET('/words/?letterPattern={letterPattern}&limit={limit}&page={page}')
  Future<DictionarySearchResponse> searchWord(
    @Path('letterPattern') String letterPattern,
    @Path('limit') int limit,
    @Path('page') int page,
  );
}
