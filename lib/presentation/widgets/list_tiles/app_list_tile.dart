import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';

class AppListTile extends ConsumerWidget {
  final Function()? onTap;
  final int index;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const AppListTile(
      {required this.index,
      this.title = '',
      this.subtitle,
      this.onTap,
      this.trailing,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
      child: Card(
        elevation: 3,
        color: isDarkTheme ? Colors.grey[850] : Colors.white,
        surfaceTintColor: Colors.white,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
              child: Text(
            formatIndexToString(index),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.bold,
            ),
          )),
          title: Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                  ),
                )
              : null,
          trailing: trailing ??
              Icon(
                Icons.play_circle_outline_outlined,
                size: ScreenUtil().setWidth(32),
                color:
                    isDarkTheme ? Colors.white : Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}
