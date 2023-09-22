import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatternLearningView extends ConsumerStatefulWidget {
  const PatternLearningView({super.key});

  @override
  ConsumerState<PatternLearningView> createState() =>
      _PatternLearningViewState();
}

class _PatternLearningViewState extends ConsumerState<PatternLearningView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Pattern Learning'),
      ),
    );
  }
}
