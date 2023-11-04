import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/record_loading_indicator.dart';

class RecordButton extends StatelessWidget {
  final ButtonState buttonState;
  final bool isDarkTheme;
  final Function()? onTap;

  const RecordButton({
    super.key,
    this.buttonState = ButtonState.normal,
    this.isDarkTheme = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setHeight(120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme ? Colors.grey[800]! : Colors.black45,
        ),
        borderRadius: BorderRadius.circular(32),
        color: Theme.of(context).primaryColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: buttonState == ButtonState.loading
            ? const RecordLoadingIndicator()
            : Icon(
                Icons.mic,
                size: ScreenUtil().setWidth(32),
                color: Colors.white,
              ),
      ),
    );
  }
}
