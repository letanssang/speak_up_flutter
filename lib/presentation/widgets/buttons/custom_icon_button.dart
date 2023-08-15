import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      margin: margin,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.grey[100],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
