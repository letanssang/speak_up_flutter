import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/resources/app_colors.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizResultBottomSheet extends StatelessWidget {
  final bool isCorrectAnswer;
  final Function()? onTap;
  final String? title;
  final String? correctAnswer;

  const QuizResultBottomSheet({
    super.key,
    this.isCorrectAnswer = true,
    this.onTap,
    this.title,
    this.correctAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  isCorrectAnswer
                      ? const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.quizResultCorrect,
                          size: 28,
                        )
                      : const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.quizResultIncorrect,
                          size: 28,
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  isCorrectAnswer
                      ? Text(AppLocalizations.of(context)!.excellent,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            fontWeight: FontWeight.bold,
                            color: AppColors.quizResultCorrect,
                          ))
                      : Text(
                          AppLocalizations.of(context)!.wrong,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            fontWeight: FontWeight.bold,
                            color: AppColors.quizResultIncorrect,
                          ),
                        ),
                ],
              ),
              if (!isCorrectAnswer)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
                  child: Text(
                    title ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (!isCorrectAnswer)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    correctAnswer ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              CustomButton(
                marginVertical: 32,
                text: 'Next',
                buttonColor: isCorrectAnswer
                    ? AppColors.quizResultCorrect
                    : AppColors.quizResultIncorrect,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
