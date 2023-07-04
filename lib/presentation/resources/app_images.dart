import 'package:flutter/material.dart';

class AppImages {
  AppImages._private();

  static const _imagesPath = 'assets/images';
  static const _logoImagesPath = 'assets/images/logos';

  static Widget facebookLogo({double? width, double? height, BoxFit? boxFit}) {
    return Image.asset(
      '$_logoImagesPath/facebook.png',
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
}
