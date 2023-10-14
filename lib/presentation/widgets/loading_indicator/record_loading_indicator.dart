import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class RecordLoadingIndicator extends StatelessWidget {
  const RecordLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(
      indicatorType: Indicator.lineScalePulseOut,
      strokeWidth: 1.0,
      colors: [
        Colors.white,
      ],
    );
  }
}
