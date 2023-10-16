import 'package:flutter/material.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';

class PronunciationButtons extends StatelessWidget {
  final String? recordPath;
  final Function()? onPlayRecord;
  final Function()? onRecordButtonTap;
  final Function()? onNextButtonTap;
  final PronunciationAssessmentStatus pronunciationAssessmentStatus;

  const PronunciationButtons(
      {super.key,
      required this.recordPath,
      required this.onPlayRecord,
      required this.onRecordButtonTap,
      required this.onNextButtonTap,
      required this.pronunciationAssessmentStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Container()),
        recordPath != null
            ? CustomIconButton(
                onPressed: onPlayRecord,
                height: 64,
                width: 64,
                icon: AppIcons.playRecord(
                  size: 32,
                  color: Colors.grey[800],
                ),
              )
            : const SizedBox(
                width: 64,
                height: 64,
              ),
        const SizedBox(
          width: 32,
        ),
        RecordButton(
          buttonState: pronunciationAssessmentStatus.getButtonState(),
          onTap: onRecordButtonTap,
        ),
        const SizedBox(
          width: 32,
        ),
        pronunciationAssessmentStatus.canMoveToNext()
            ? CustomIconButton(
                height: 64,
                width: 64,
                onPressed: onNextButtonTap,
                icon: Icon(
                  Icons.navigate_next_outlined,
                  size: 32,
                  color: Colors.grey[800],
                ))
            : const SizedBox(
                width: 64,
                height: 64,
              ),
        Flexible(child: Container()),
      ],
    );
  }
}
