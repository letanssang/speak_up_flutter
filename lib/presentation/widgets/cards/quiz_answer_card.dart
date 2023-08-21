import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/resources/app_colors.dart';

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

class QuizAnswerCard extends StatelessWidget {
  final int index;
  final String answer;
  final bool isCorrectAnswer;

  const QuizAnswerCard({
    super.key,
    required this.index,
    required this.answer,
    required this.isCorrectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getAnswerOptionColor(index),
      elevation: 3,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(14),
            ),
          ),
        ),
      ),
    );
  }
}
