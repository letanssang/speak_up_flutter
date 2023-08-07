import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/presentation/pages/lesson/lesson_state.dart';

class LessonViewModel extends StateNotifier<LessonState> {
  LessonViewModel() : super(const LessonState());
}
