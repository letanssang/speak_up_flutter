import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';

class CustomButton extends StatelessWidget {
  final double? height;
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
  final double? textSize;

  const CustomButton({
    super.key,
    this.height,
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
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(8),
        vertical:
            ScreenUtil().setHeight(ScreenUtil().setHeight(marginVertical)),
      ),
      height: height != null
          ? ScreenUtil().setHeight(height!)
          : ScreenUtil().setHeight(50),
      width: width ?? ScreenUtil().screenWidth * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:
              buttonState == ButtonState.disabled ? Colors.grey : buttonColor,
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800]!.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ]),
      child: InkWell(
        onTap: buttonState == ButtonState.normal ? onTap : null,
        child: Center(
          child: Row(
            mainAxisAlignment: image != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (image != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(32)),
                  child: image!,
                ),
              buttonState == ButtonState.loading
                  ? SizedBox(
                      height: ScreenUtil().setHeight(15),
                      width: ScreenUtil().setHeight(15),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: textSize ?? ScreenUtil().setSp(16),
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
