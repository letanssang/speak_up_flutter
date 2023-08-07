import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_state.dart';

class PatternViewModel extends StateNotifier<PatternState> {
  PatternViewModel() : super(const PatternState());
}
