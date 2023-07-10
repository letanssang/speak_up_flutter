import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';

import '../../widgets/buttons/custom_button.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();
  double _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _currentIndex = _pageController.page ?? 0;
        });
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().statusBarHeight * 1.5,
                      right: ScreenUtil().setWidth(16),
                    ),
                    child: TextButton(
                        onPressed: () {
                          ref
                              .read(appNavigatorProvider)
                              .navigateTo(AppRoutes.mainMenu);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                    itemCount: 3,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return buildPageViewItem(
                          index, splashTitles[index], splashSubtitles[index]);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DotsIndicator(
                  dotsCount: 3,
                  position: _currentIndex,
                  decorator: DotsDecorator(
                    color: Colors.grey,
                    activeColor: Theme.of(context).primaryColor,
                    activeShape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(ScreenUtil().setHeight(5)),
                    ),
                  ),
                ),
              ),
              CustomButton(
                  text: 'Get Started',
                  onTap: () {
                    ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.signUp,
                    );
                  }),
              CustomButton(
                text: 'I have an account',
                buttonColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                onTap: () {
                  ref.read(appNavigatorProvider).navigateTo(
                    AppRoutes.signIn,
                  );
                },
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              SizedBox(
                height: ScreenUtil().screenHeight * 0.1,
              ),
            ],
          )),
    );
  }

  Column buildPageViewItem(int index, String title, String subTitle) {
    return Column(
      children: [
        AppImages.onboarding(
          index,
          width: ScreenUtil().screenWidth * 0.8,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(24),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
      ],
    );
  }
}