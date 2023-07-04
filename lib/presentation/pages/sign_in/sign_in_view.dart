import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SizedBox(
        width: ScreenUtil().screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Welcome back!\nSign in to continue',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            CustomButton(
              text: 'Sign in with Google',
              height: 60,
              textColor: Colors.black,
              buttonColor: Color(0xFFEBECEE),
              fontWeight: FontWeight.w600,
              image: AppImages.googleLogo(),
            ),
            CustomButton(
              text: 'Sign in with Facebook',
              height: 60,
              textColor: Colors.white,
              buttonColor: Color(0xFF3B5998),
              fontWeight: FontWeight.w600,
              image: AppImages.facebookLogo(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('or',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w600,
                  )),
            ),
            TextButton(
                onPressed: () {
                  ref.read(appNavigatorProvider).navigateTo(
                    AppRoutes.signInEmail,
                  );
                },
                child: Text('Sign in with email',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600,
                    ))),
            Flexible(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}