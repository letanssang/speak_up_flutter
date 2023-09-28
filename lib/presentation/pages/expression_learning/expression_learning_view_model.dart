import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/presentation/pages/expression_learning/expression_learning_state.dart';

class ExpressionLearningViewModel
    extends StateNotifier<ExpressionLearningState> {
  ExpressionLearningViewModel(
    this._speakFromTextUseCase,
  ) : super(const ExpressionLearningState());

  final SpeakFromTextUseCase _speakFromTextUseCase;

  void speak(String text) async {
    await _speakFromTextUseCase.run(text);
  }
}
