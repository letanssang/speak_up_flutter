import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Color color;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final double? size;
  const AppBackButton({
    super.key,
    this.color = Colors.black,
    this.onPressed,
    this.padding,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 16.0),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: size ?? 24,
          color: color,
        ),
        onPressed: onPressed ??
            () {
              Navigator.of(context).pop();
            },
      ),
    );
  }
}
