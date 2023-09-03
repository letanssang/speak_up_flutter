import 'package:speak_up/data/models/dictionary/word_detail_response.dart';
import 'package:speak_up/data/repositories/dictionary/dictionary_repository.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetWordDetailUseCase extends FutureUseCase<String, WordDetailResponse> {
  @override
  Future<WordDetailResponse> run(String input) {
    return injector.get<DictionaryRepository>().getWordDetail(
          input,
        );
  }
}
