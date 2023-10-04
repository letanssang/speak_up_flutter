import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/domain/use_cases/use_case.dart';
import 'package:speak_up/injection/injector.dart';

class GetPhoneticListUseCase implements FutureOutputUseCase<List<Phonetic>> {
  @override
  Future<List<Phonetic>> run() async {
    return await injector.get<LocalDatabaseRepository>().getPhoneticList();
  }
}
