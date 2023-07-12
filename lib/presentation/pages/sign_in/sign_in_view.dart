import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_goole_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/sign_in/sign_in_state.dart';
import 'package:speak_up/presentation/pages/sign_in/sign_in_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final signInViewModelProvider =
    StateNotifierProvider.autoDispose<SignInViewModel, SignInState>(
        (ref) => SignInViewModel(
              injector.get<SignInWithGoogleUseCase>(),
            ));

class SignInView extends ConsumerWidget {
  const SignInView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInViewModelProvider);
    ref.listen(signInViewModelProvider.select((value) => value.loadingStatus),
        (previous, next) {
      if (next == LoadingStatus.success) {
        Future.delayed(const Duration(seconds: 1), () {
          ref.read(appNavigatorProvider).navigateTo(
                AppRoutes.mainMenu,
                shouldClearStack: true,
              );
        });
      }
    });
    ref.listen(signInViewModelProvider.select((value) => value.errorMessage),
        (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
          ),
        );
      }
      ref.read(signInViewModelProvider.notifier).resetError();
    });
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: ScreenUtil().screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Welcome!\nSign in to continue',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  text: 'Continue with Google',
                  height: 60,
                  textColor: Colors.black,
                  buttonColor: const Color(0xFFEBECEE),
                  fontWeight: FontWeight.w600,
                  image: AppImages.googleLogo(),
                  onTap: () {
                    ref
                        .read(signInViewModelProvider.notifier)
                        .signInWithGoogle();
                  },
                ),
                CustomButton(
                  text: 'Continue with Facebook',
                  height: 60,
                  textColor: Colors.white,
                  buttonColor: const Color(0xFF3B5998),
                  fontWeight: FontWeight.w600,
                  image: AppImages.facebookLogo(),
                ),
                CustomButton(
                    text: 'Sign in with email',
                    height: 60,
                    textColor: Colors.black,
                    buttonColor: const Color(0xFFEBECEE),
                    fontWeight: FontWeight.w600,
                    image: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    onTap: () {
                      ref.read(appNavigatorProvider).navigateTo(
                            AppRoutes.signInEmail,
                          );
                    }),
                SizedBox(
                  height: ScreenUtil().setHeight(32),
                ),
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      ref.read(appNavigatorProvider).navigateTo(
                            AppRoutes.signUpEmail,
                          );
                    },
                    child: Text('Sign up',
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
          if (state.loadingStatus == LoadingStatus.success)
            AppLoadingIndicator(),
        ],
      ),
    );
  }
}
