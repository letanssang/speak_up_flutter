import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double? width;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final BoxBorder? border;
  final Function()? onTap;
  final FontWeight? fontWeight;
  final Widget? image;
  final double marginVertical;
  final ButtonState buttonState;

  const CustomButton({
    super.key,
    this.height = 50,
    this.width,
    required this.text,
    this.buttonColor = const Color(0xFF50248F),
    this.textColor = Colors.white,
    this.border,
    this.fontWeight,
    this.onTap,
    this.image,
    this.marginVertical = 10,
    this.buttonState = ButtonState.normal,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonState == ButtonState.normal  ? onTap : null,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(8),
          vertical: ScreenUtil().setHeight(marginVertical),
        ),
        height: height,
        width: width ?? ScreenUtil().screenWidth * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonState == ButtonState.disabled ? Colors.grey : buttonColor,
          border: border,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (image != null) image!,
              buttonState == ButtonState.loading ?
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                  : Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
