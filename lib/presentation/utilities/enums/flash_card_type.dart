import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FlashCardType {
  idiom,
  phrasalVerb,
  pattern,
  expression,
}

extension FlashCardTypeExtension on FlashCardType {
  String getTapBackDescription(BuildContext context) {
    switch (this) {
      case FlashCardType.idiom:
        return AppLocalizations.of(context)!.tapToSeeTheIdiom;
      case FlashCardType.phrasalVerb:
        return AppLocalizations.of(context)!.tapToSeeThePhrasalVerb;
      case FlashCardType.pattern:
        return AppLocalizations.of(context)!.tapToSeeThePattern;
      case FlashCardType.expression:
        return AppLocalizations.of(context)!.tapToSeeTheExpression;
      default:
        return '';
    }
  }
}
