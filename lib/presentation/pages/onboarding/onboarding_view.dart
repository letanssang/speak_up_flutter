import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/account_settings/save_app_language_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/constant/string.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

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
    final language = ref.watch(appLanguageProvider);
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
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil().statusBarHeight + 16,
                    horizontal: 16),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    if (language == Language.english) {
                      ref.read(appLanguageProvider.notifier).state =
                          Language.vietnamese;
                    } else {
                      ref.read(appLanguageProvider.notifier).state =
                          Language.english;
                    }
                    injector
                        .get<SaveAppLanguageUseCase>()
                        .run(ref.read(appLanguageProvider.notifier).state);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(8),
                            vertical: ScreenUtil().setHeight(4)),
                        child: Text(language.toLanguageShortString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      language.getFlag(),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: ScreenUtil().screenHeight * 0.5,
            child: PageView.builder(
                itemCount: 3,
                controller: _pageController,
                itemBuilder: (context, index) {
                  return buildPageViewItem(
                      index,
                      getSplashTitle(index, context),
                      getSplashSubtitle(index, context));
                }),
          ),
          Flexible(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
              height: 60,
              text: AppLocalizations.of(context)!.getStarted,
              onTap: () {
                ref.read(appNavigatorProvider).navigateTo(
                      AppRoutes.signIn,
                    );
              }),
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
        Expanded(
          child: AppImages.onboarding(
            index,
            width: ScreenUtil().screenWidth * 0.7,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              fontWeight: FontWeight.w600,
            ),
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
