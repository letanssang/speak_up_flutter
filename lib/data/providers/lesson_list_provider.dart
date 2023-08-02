import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_lesson_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';

final lessonListProvider = FutureProvider<List<Lesson>>((ref) async {
  return await injector.get<GetLessonListUseCase>().run();
});
