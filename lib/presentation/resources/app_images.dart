import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppImages {
  AppImages._private();

  static const _imagesPath = 'assets/images';
  static const _logoImagesPath = 'assets/images/logos';
  static const _categoriesImagesPath = 'assets/images/categories';

  static Widget chatbot({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/chatbot.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget congrats({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/congrats.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget signIn({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/sign_in.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget signUp({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/sign_up.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget signInEmail({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/sign_in_email.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget error({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/error.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget searchSomething(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/search_something.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget noData({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/no_data.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget googleLogo({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_logoImagesPath/google.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget usFlag({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_logoImagesPath/us.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget developer({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/developer.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget vnFlag({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_logoImagesPath/vietnam.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget avatar({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/avatar.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget questioner({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/questioner.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget respondent({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/respondent.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget onboarding(int index,
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/onboarding$index.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget activeLifestyle(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/active_lifestyle.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget art({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/art.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget business({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/business.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget community({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/community.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget dining({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/dining.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget entertainment({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/entertainment.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget fashion({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/fashion.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget festivities({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/festivities.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget health({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/health.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget literature({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/literature.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget memorableEvents(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/memorable_events.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget onlinePresence(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/online_presence.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget personalDevelopment(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/personal_development.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget relationship({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/relationship.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget technology({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/technology.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget travel({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/travel.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget urbanLife({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/urban_life.png',
      width: width ?? ScreenUtil().setWidth(100),
      height: height ?? ScreenUtil().setHeight(100),
      fit: boxFit,
    );
  }

  static Widget appBanner({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/banner.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }
}
