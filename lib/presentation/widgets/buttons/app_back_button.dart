import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';

class AppBackButton extends ConsumerWidget {
  final Function()? onPressed;
  final EdgeInsets? padding;
  final double? size;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.padding,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 16),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: size ?? ScreenUtil().setHeight(22),
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        onPressed: onPressed ??
            () {
              Navigator.of(context).pop();
            },
      ),
    );
  }
}
