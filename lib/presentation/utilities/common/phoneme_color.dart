import 'package:flutter/material.dart';

Color getPhonemeColor(double score) {
  if (score >= 80) {
    return const Color(0xFF00890A);
  } else if (score >= 60) {
    return const Color(0xFFFFD700);
  } else {
    return Colors.red;
  }
}
