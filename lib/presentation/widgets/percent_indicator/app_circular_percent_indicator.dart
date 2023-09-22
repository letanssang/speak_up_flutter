import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AppCircularPercentIndicator extends StatelessWidget {
  final String title;
  final double percent;
  final double radius;
  final Color? progressColor;
  final EdgeInsets padding;
  const AppCircularPercentIndicator({
    super.key,
    required this.title,
    required this.percent,
    this.radius = 40,
    this.padding = const EdgeInsets.all(8),
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CircularPercentIndicator(
        radius: radius,
        lineWidth: 8.0,
        percent: percent,
        center: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
