import 'package:flutter/material.dart';
import 'package:speak_up/presentation/resources/app_colors.dart';

enum QuizAnswerCardStatus { before, after }

extension QuizAnswerCardTypeExtension on QuizAnswerCardStatus {
  Color getColor(int index, bool isCorrectAnswer) {
    switch (this) {
      case QuizAnswerCardStatus.before:
        return getAnswerOptionColor(index);
      case QuizAnswerCardStatus.after:
        return getAfterAnswerOptionColor(isCorrectAnswer);
      default:
        return Colors.white;
    }
  }
}

Color getAnswerOptionColor(int index) {
  switch (index) {
    case 0:
      return AppColors.quizAnswerOption1;
    case 1:
      return AppColors.quizAnswerOption2;
    case 2:
      return AppColors.quizAnswerOption3;
    case 3:
      return AppColors.quizAnswerOption4;
    default:
      return AppColors.quizAnswerOption1;
  }
}

Color getAfterAnswerOptionColor(bool isCorrectAnswer) {
  if (isCorrectAnswer) {
    return AppColors.quizResultCorrect;
  } else {
    return AppColors.quizResultIncorrect;
  }
}
