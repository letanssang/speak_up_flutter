import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('About'),
      ),
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Speak Up',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppImages.developer(
              width: ScreenUtil().screenWidth * 0.6,
              boxFit: BoxFit.fitWidth,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Made with ❤️ by chugacon',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Contact me for any problem:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            ),
            Text('letan.ssang@gmail.com',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }
}
