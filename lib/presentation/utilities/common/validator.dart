import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? validateEmail(String? email, BuildContext context) {
  if (email == null || email.isEmpty) {
    return AppLocalizations.of(context)!.emailIsRequired;
  }
  const String regex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final RegExp regExp = RegExp(regex);
  if (!regExp.hasMatch(email)) {
    return AppLocalizations.of(context)!.enterAValidEmail;
  }
  return null;
}

String? validateUserName(String? userName, BuildContext context) {
  if (userName == null || userName.isEmpty) {
    return AppLocalizations.of(context)!.userNameIsRequired;
  }
  if (userName.length < 6) {
    return AppLocalizations.of(context)!.userNameMustBeAtLeast6Characters;
  }
  if (userName.length > 20) {
    return AppLocalizations.of(context)!.userNameMustNotExceed20Characters;
  }
  return null;
}

String? validatePassword(String? password, BuildContext context) {
  if (password == null || password.isEmpty) {
    return AppLocalizations.of(context)!.passwordIsRequired;
  }
  if (password.length < 6) {
    return AppLocalizations.of(context)!.passwordMustBeAtLeast6Characters;
  }
  return null;
}
