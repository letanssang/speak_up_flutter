import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon {
  SvgIcon._private();

  static SvgPicture from(
    String assetName, {
    Key? key,
    double? width,
    double? height,
    double? size,
    Color? color,
    BoxFit? fit,
  }) =>
      SvgPicture.asset(
        assetName,
        key: key,
        width: size ?? width,
        height: size ?? height,
        colorFilter:
            color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        fit: fit ?? BoxFit.contain,
      );
}
