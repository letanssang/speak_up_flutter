import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum LessonType {
  idiom,
  phrasalVerb,
  pattern,
  expression,
}

extension LessonTypeExtension on LessonType {
  String getTapBackDescription(BuildContext context) {
    switch (this) {
      case LessonType.idiom:
        return AppLocalizations.of(context)!.tapToSeeTheIdiom;
      case LessonType.phrasalVerb:
        return AppLocalizations.of(context)!.tapToSeeThePhrasalVerb;
      case LessonType.pattern:
        return AppLocalizations.of(context)!.tapToSeeThePattern;
      case LessonType.expression:
        return AppLocalizations.of(context)!.tapToSeeTheExpression;
      default:
        return '';
    }
  }
}
