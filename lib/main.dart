import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/injection/app_modules.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/resources/app_theme.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';

import 'injection/injector.dart';
import 'presentation/navigation/app_router.dart';

final appRootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await AppModules.inject();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await injector.allReady();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(
        child: MyApp(),
      ), // Wrap your app
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            title: 'Speak Up',
            debugShowCheckedModeBanner: false,
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: getAppLightTheme(),
            darkTheme: getAppDarkTheme(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: language.getLocale(),
            navigatorKey: appRootNavigatorKey,
            home: WillPopScope(
              onWillPop: () async {
                final navigator = ref.read(appNavigatorProvider);
                if (navigator.canGoBack()) {
                  navigator.pop();
                  return false;
                }
                return false;
              },
              child: Navigator(
                key: ref.read(appNavigatorProvider).navigatorKey,
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRouter.onGenerateRoute,
              ),
            ),
          );
        });
  }
}
