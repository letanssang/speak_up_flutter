import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatternView extends ConsumerStatefulWidget {
  const PatternView({super.key});

  @override
  ConsumerState<PatternView> createState() => _PatternViewState();
}

class _PatternViewState extends ConsumerState<PatternView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
