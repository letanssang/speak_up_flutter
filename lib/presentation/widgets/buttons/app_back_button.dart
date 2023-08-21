import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
