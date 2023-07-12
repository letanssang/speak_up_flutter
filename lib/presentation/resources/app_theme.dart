import 'package:flutter/material.dart';

ThemeData getAppLightTheme() {
  return ThemeData(
    fontFamily: 'SF Pro Display',
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'SF Pro Display',
        ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'SF Pro Display',
      ),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      surfaceTintColor: Colors.white,
    ),
    primaryColor: const Color(0xFF50248F),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF50248F)),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: Colors.black),
  );
}

ThemeData getAppDarkTheme() {
  return ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SF Pro Display',
        ),
    dialogTheme: const DialogTheme(
      surfaceTintColor: Colors.white,
    ),
    dialogBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'SF Pro Display',
      ),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.white,
    ),
    primaryColor: const Color(0xFF50248F),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF50248F)),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
