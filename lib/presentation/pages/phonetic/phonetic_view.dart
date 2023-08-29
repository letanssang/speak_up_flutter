import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneticView extends ConsumerStatefulWidget {
  const PhoneticView({super.key});

  @override
  ConsumerState<PhoneticView> createState() => _PhoneticViewState();
}

class _PhoneticViewState extends ConsumerState<PhoneticView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phonetic'),
      ),
      body: Container(),
    );
  }
}
