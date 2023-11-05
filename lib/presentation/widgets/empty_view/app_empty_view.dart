import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

class AppEmptyView extends ConsumerWidget {
  const AppEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImages.noData(
            width: ScreenUtil().screenWidth * 0.5,
            height: ScreenUtil().screenWidth * 0.5,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            AppLocalizations.of(context)!.nothingHere,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(AppLocalizations.of(context)!.letExploreAndSaveSomeThings,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: Colors.grey[600],
              )),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.explore,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
