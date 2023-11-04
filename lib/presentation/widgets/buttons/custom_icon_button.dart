import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';

class CustomIconButton extends ConsumerWidget {
  final double height;
  final double width;
  final Widget icon;
  final Function()? onPressed;
  final EdgeInsetsGeometry? margin;

  const CustomIconButton({
    super.key,
    this.height = 48,
    this.width = 48,
    required this.icon,
    this.onPressed,
    this.margin = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Container(
      height: height,
      width: height,
      margin: margin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: isDarkTheme ? Colors.grey[700]! : Colors.grey[300]!),
        color: isDarkTheme ? Colors.grey[800] : Colors.grey[100],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
