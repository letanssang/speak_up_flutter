import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/pronunciation_assessment_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';

class PronunciationButtons extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Row(
      children: [
        Flexible(child: Container()),
        recordPath != null
            ? CustomIconButton(
                onPressed: onPlayRecord,
                height: ScreenUtil().setHeight(64),
                width: ScreenUtil().setWidth(64),
                icon: AppIcons.playRecord(
                  size: ScreenUtil().setSp(32),
                  color: isDarkTheme ? Colors.grey[300] : Colors.grey[800],
                ),
              )
            : SizedBox(
                width: ScreenUtil().setWidth(64),
                height: ScreenUtil().setHeight(64),
              ),
        const SizedBox(
          width: 32,
        ),
        RecordButton(
          buttonState: pronunciationAssessmentStatus.getButtonState(),
          onTap: onRecordButtonTap,
          isDarkTheme: isDarkTheme,
        ),
        const SizedBox(
          width: 32,
        ),
        pronunciationAssessmentStatus.canMoveToNext()
            ? CustomIconButton(
                height: ScreenUtil().setHeight(64),
                width: ScreenUtil().setWidth(64),
                onPressed: onNextButtonTap,
                icon: Icon(
                  Icons.navigate_next_outlined,
                  size: ScreenUtil().setSp(32),
                  color: isDarkTheme ? Colors.grey[300] : Colors.grey[800],
                ))
            : SizedBox(
                width: ScreenUtil().setWidth(64),
                height: ScreenUtil().setHeight(64),
              ),
        Flexible(child: Container()),
      ],
    );
  }
}
