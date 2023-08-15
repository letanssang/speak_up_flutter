import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/record_loading_indicator.dart';

class RecordButton extends StatelessWidget {
  final ButtonState buttonState;
  final Function()? onTap;

  const RecordButton({
    super.key,
    this.buttonState = ButtonState.normal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setHeight(120),
      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(32),
        color: Colors.grey[100],
      ),
      child: InkWell(
        onTap: onTap,
        child: buttonState == ButtonState.loading
            ? const RecordLoadingIndicator()
            : Icon(
                Icons.mic,
                size: ScreenUtil().setWidth(32),
                color: Colors.grey[800],
              ),
      ),
    );
  }
}