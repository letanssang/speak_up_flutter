import 'package:flutter/widgets.dart';
import 'package:speak_up/presentation/widgets/svg_icon.dart';

class AppIcons {
  AppIcons._private();

  static const _iconsPath = 'assets/icons';
  static const _categoriesIconPath = 'assets/icons/categories';

  static Widget filter({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/filter.svg',
      color: color,
      size: size,
    );
  }

  static Widget about({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/about.svg',
      color: color,
      size: size,
    );
  }

  static Widget darkMode({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/dark_mode.svg',
      color: color,
      size: size,
    );
  }

  static Widget changeLanguage({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/change_language.svg',
      color: color,
      size: size,
    );
  }

  static Widget changePassword({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/change_password.svg',
      color: color,
      size: size,
    );
  }

  static Widget logout({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/logout.svg',
      color: color,
      size: size,
    );
  }

  static Widget avatar({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/avatar.svg',
      color: color,
      size: size,
    );
  }

  static Widget snail({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/snail.svg',
      color: color,
      size: size,
    );
  }

  static Widget playRecord({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_iconsPath/play_record.svg',
      color: color,
      size: size,
    );
  }

  static Widget activeLifestyle({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/active_lifestyle.svg',
      color: color,
      size: size,
    );
  }

  static Widget art({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/art.svg',
      color: color,
      size: size,
    );
  }

  static Widget business({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/business.svg',
      color: color,
      size: size,
    );
  }

  static Widget community({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/community.svg',
      color: color,
      size: size,
    );
  }

  static Widget dining({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/dining.svg',
      color: color,
      size: size,
    );
  }

  static Widget entertainment({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/entertainment.svg',
      color: color,
      size: size,
    );
  }

  static Widget fashion({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/fashion.svg',
      color: color,
      size: size,
    );
  }

  static Widget festivities({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/festivities.svg',
      color: color,
      size: size,
    );
  }

  static Widget health({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/health.svg',
      color: color,
      size: size,
    );
  }

  static Widget literature({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/literature.svg',
      color: color,
      size: size,
    );
  }

  static Widget memorableEvents({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/memorable_events.svg',
      color: color,
      size: size,
    );
  }

  static Widget personalDevelopment({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/personal_development.svg',
      color: color,
      size: size,
    );
  }

  static Widget onlinePresence({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/online_presence.svg',
      color: color,
      size: size,
    );
  }

  static Widget relationship({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/relationship.svg',
      color: color,
      size: size,
    );
  }

  static Widget technology({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/technology.svg',
      color: color,
      size: size,
    );
  }

  static Widget travel({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/travel.svg',
      color: color,
      size: size,
    );
  }

  static Widget urbanLife({
    Color? color,
    double? size,
  }) {
    return SvgIcon.from(
      '$_categoriesIconPath/urban_life.svg',
      color: color,
      size: size,
    );
  }
}
