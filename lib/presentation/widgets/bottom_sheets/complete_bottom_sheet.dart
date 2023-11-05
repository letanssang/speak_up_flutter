import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/presentation/resources/app_colors.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

import '../buttons/custom_button.dart';

void showCompleteBottomSheet(BuildContext context, {String? title}) {
  showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return CompleteBottomSheet(
          title: title,
        );
      });
}

class CompleteBottomSheet extends ConsumerWidget {
  final String? title;

  const CompleteBottomSheet({this.title, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Wrap(
      children: [
        Container(
          width: ScreenUtil().screenWidth,
          color: isDarkTheme ? Colors.grey[900] : Colors.white,
          child: Column(children: [
            const SizedBox(
              height: 32,
            ),
            Text(AppLocalizations.of(context)!.congratulations,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.quizResultCorrect,
                )),
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.bold,
                    )),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppImages.congrats(
                height: ScreenUtil().setHeight(128),
                boxFit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
                text: AppLocalizations.of(context)!.exit,
                fontWeight: FontWeight.bold,
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(appNavigatorProvider).pop();
                }),
            const SizedBox(
              height: 16,
            ),
          ]),
        ),
      ],
    );
  }
}
