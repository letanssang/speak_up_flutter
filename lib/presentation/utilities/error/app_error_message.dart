import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getAppErrorMessage(String code, BuildContext context) {
  switch (code) {
    case 'invalid-email':
      return AppLocalizations.of(context)!.invalidEmail;
    case 'user-not-found':
      return AppLocalizations.of(context)!.userNotFound;
    case 'wrong-password':
      return AppLocalizations.of(context)!.wrongPassword;
    case 'email-already-in-use':
      return AppLocalizations.of(context)!.emailAlreadyInUse;
    case 'weak-password':
      return AppLocalizations.of(context)!.weakPassword;
    case 'too-many-requests':
      return AppLocalizations.of(context)!.tooManyRequests;
    case 'operation-not-allowed':
      return AppLocalizations.of(context)!.operationNotAllowed;
    case 'requires-recent-login':
      return AppLocalizations.of(context)!.requiresRecentLogin;
    case 'user-disabled':
      return AppLocalizations.of(context)!.userDisabled;
    case "account-exists-with-different-credential":
      return AppLocalizations.of(context)!.accountExistsWithDifferentCredential;
    case "invalid-credential":
      return AppLocalizations.of(context)!.invalidCredential;
    case "invalid-verification-code":
      return AppLocalizations.of(context)!.invalidVerificationCode;
    case "invalid-verification-id":
      return AppLocalizations.of(context)!.invalidVerificationId;
    case "user-mismatch":
      return AppLocalizations.of(context)!.userMismatch;
    default:
      return AppLocalizations.of(context)!.somethingWentWrong;
  }
}
