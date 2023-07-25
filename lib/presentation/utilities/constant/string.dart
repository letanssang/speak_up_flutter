import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String dailyConversationURL =
    'https://basicenglishspeaking.com/wp-content/uploads/audio/QA/';
const String audioExtension = '.mp3';
String getSplashTitle(int index, BuildContext context) {
  switch (index) {
    case 0:
      return AppLocalizations.of(context)!.welcomeToSpeakUp;
    case 1:
      return AppLocalizations.of(context)!.exploreYourVoiceWithUs;
    case 2:
      return AppLocalizations.of(context)!.conversationIsTheKey;
    default:
      return '';
  }
}

String getSplashSubtitle(int index, BuildContext context) {
  switch (index) {
    case 0:
      return AppLocalizations.of(context)!.letsStartSpeakingEnglish;
    case 1:
      return AppLocalizations.of(context)!.speakUpAndBeHeard;
    case 2:
      return AppLocalizations.of(context)!.practiceMakesPerfect;
    default:
      return '';
  }
}
