import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/injection/app_modules.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';

import 'gen/firebase_options.dart';
import 'injection/injector.dart';
import 'presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppModules.inject();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await injector.allReady();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final isDarkTheme = ref.watch(themeProvider);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            themeMode: ThemeMode.dark,
            theme: ThemeData(
              fontFamily: 'SF Pro Display',
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0,
              ),
              primaryColor: const Color(0xFF50248F),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF50248F)),
              useMaterial3: true,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            darkTheme: ThemeData.dark().copyWith(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              primaryColor: const Color(0xFF50248F),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF50248F)),
              useMaterial3: true,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            home: Navigator(
              key: ref.read(appNavigatorProvider).navigatorKey,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
            ),
          );
        });
  }
}
