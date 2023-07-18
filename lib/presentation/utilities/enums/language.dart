import 'package:flutter/cupertino.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

enum Language {
  english,
  vietnamese,
}

extension LanguageExtension on Language {
  String toLanguageString() {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.vietnamese:
        return 'Tiếng Việt';
      default:
        return '';
    }
  }

  String toLanguageShortString() {
    switch (this) {
      case Language.english:
        return 'en';
      case Language.vietnamese:
        return 'vi';
      default:
        return '';
    }
  }

  Locale getLocale() {
    switch (this) {
      case Language.english:
        return const Locale('en');
      case Language.vietnamese:
        return const Locale('vi');
      default:
        return const Locale('en');
    }
  }

  Widget getFlag() {
    switch (this) {
      case Language.english:
        return AppImages.usFlag(
          width: 24,
          height: 24,
        );
      case Language.vietnamese:
        return AppImages.vnFlag(
          width: 24,
          height: 24,
        );
      default:
        return AppImages.usFlag(
          width: 24,
          height: 24,
        );
    }
  }
}
