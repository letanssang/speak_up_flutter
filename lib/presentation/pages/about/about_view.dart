import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.about,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
            )),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
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
                '${AppLocalizations.of(context)!.developedBy} motchugacon',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                AppLocalizations.of(context)!.contactMeForAnyProblems,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),
              const SizedBox(
                height: 8,
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
      ),
    );
  }
}
