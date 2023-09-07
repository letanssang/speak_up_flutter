import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/utilities/enums/quiz_answer_card_status.dart';

class QuizAnswerCard extends StatelessWidget {
  final int index;
  final String answer;
  final bool isCorrectAnswer;
  final QuizAnswerCardStatus quizAnswerCardStatus;
  final Function()? onTap;

  const QuizAnswerCard({
    super.key,
    required this.index,
    required this.answer,
    required this.isCorrectAnswer,
    required this.quizAnswerCardStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: quizAnswerCardStatus.getColor(index, isCorrectAnswer),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              if (quizAnswerCardStatus == QuizAnswerCardStatus.after)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    isCorrectAnswer
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: Colors.white,
                    size: ScreenUtil().setSp(24),
                  ),
                ),
              Center(
                child: SingleChildScrollView(
                  child: Text(
                    answer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
