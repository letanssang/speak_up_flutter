import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('About'),
      ),
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Speak Up'),
            Text('Made with ❤️ by Le Tan Sang'),
          ],
        ),
      ),
    );
  }
}
