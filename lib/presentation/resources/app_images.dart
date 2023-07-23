import 'package:flutter/material.dart';

class AppImages {
  AppImages._private();

  static const _imagesPath = 'assets/images';
  static const _logoImagesPath = 'assets/images/logos';
  static const _categoriesImagesPath = 'assets/images/categories';

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

  static Widget onboarding(int index,
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/onboarding$index.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget nothingHere({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_imagesPath/nothing_here.png',
      width: width,
      height: height,
      fit: boxFit,
    );
  }

  static Widget activeLifestyle(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/active_lifestyle.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget art({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/art.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget business({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/business.png',
      width: width ?? 100,
      height: height ?? 100,
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
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget entertainment({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/entertainment.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget fashion({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/fashion.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget festivities({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/festivities.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget health({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/health.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget literature({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/literature.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget memorableEvents(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/memorable_events.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget onlinePresence(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/online_presence.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget personalDevelopment(
      {double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/personal_development.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget relationship({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/relationship.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget technology({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/technology.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget travel({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/travel.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }

  static Widget urbanLife({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_categoriesImagesPath/urban_life.png',
      width: width ?? 100,
      height: height ?? 100,
      fit: boxFit,
    );
  }
}
