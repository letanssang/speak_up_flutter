import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

import '../buttons/custom_button.dart';

class CompleteBottomSheet extends ConsumerWidget {
  final Function()? onClosed;

  const CompleteBottomSheet({super.key, this.onClosed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        SizedBox(
          width: ScreenUtil().screenWidth,
          child: Column(children: [
            const SizedBox(
              height: 32,
            ),
            Text(AppLocalizations.of(context)!.congratulations,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppImages.congrats(
                height: 128,
                boxFit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
                text: AppLocalizations.of(context)!.exit,
                fontWeight: FontWeight.bold,
                textSize: 16,
                marginVertical: 16,
                onTap: () {
                  onClosed?.call();
                  Navigator.of(context).pop();
                  ref.read(appNavigatorProvider).pop();
                }),
            const SizedBox(
              height: 32,
            ),
          ]),
        ),
      ],
    );
  }
}
