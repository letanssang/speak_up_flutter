import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/utilities/common/validator.dart';
import 'package:speak_up/presentation/utilities/enums/validator_type.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Icon? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final bool obscureText;
  final ValidatorType? validatorType;
  final int? errorMaxLines;
  final String? aboveText;
  final void Function()? onSuffixIconTap;
  final double? width;
  final BuildContext context;

  const CustomTextField(
      {super.key,
      this.hintText,
      this.suffixIcon,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.controller,
      this.obscureText = false,
      this.validatorType,
      this.errorMaxLines = 1,
      this.aboveText,
      this.onSuffixIconTap,
      this.width,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(24),
          vertical: ScreenUtil().setHeight(8)),
      width: width ?? ScreenUtil().screenWidth * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aboveText != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                aboveText!,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),
            ),
          TextFormField(
            validator: (value) {
              switch (validatorType) {
                case ValidatorType.email:
                  return validateEmail(value!, context);
                case ValidatorType.password:
                  return validatePassword(value!, context);
                case ValidatorType.userName:
                  return validateUserName(value!, context);
                default:
                  return null;
              }
            },
            obscureText: obscureText,
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            onTapOutside: (focusNode) {
              FocusScope.of(context).unfocus();
            },
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
            ),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              errorMaxLines: errorMaxLines,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
              suffixIcon: InkWell(onTap: onSuffixIconTap, child: suffixIcon),
              suffixIconColor: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
