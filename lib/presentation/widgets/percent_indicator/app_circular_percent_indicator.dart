import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AppCircularPercentIndicator extends StatelessWidget {
  final String title;
  final double titleSize;
  final double percent;
  final double radius;
  final Color? progressColor;
  final EdgeInsets padding;
  final double lineWidth;

  const AppCircularPercentIndicator({
    super.key,
    required this.title,
    this.titleSize = 14,
    required this.percent,
    this.radius = 40,
    this.padding = const EdgeInsets.all(8),
    this.progressColor,
    this.lineWidth = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CircularPercentIndicator(
        radius: radius,
        lineWidth: lineWidth,
        percent: percent,
        center: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleSize,
          ),
        ),
        progressColor: progressColor ?? Theme.of(context).primaryColor,
        backgroundColor: Colors.grey,
        animation: true,
        animationDuration: 1000,
      ),
    );
  }
}
