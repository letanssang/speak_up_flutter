import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Icon? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? errorMaxLines;
  final String? aboveText;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.errorMaxLines = 1,
    this.aboveText,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setHeight(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aboveText != null)
            Padding(
              padding:
              EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
              child: Text(
                aboveText!,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          TextFormField(
            initialValue: initialValue,
            validator: validator,
            obscureText: obscureText,
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            onTapOutside: (focusNode) {
              FocusScope.of(context).unfocus();
            },
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
              suffixIcon: suffixIcon,
              suffixIconColor: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}