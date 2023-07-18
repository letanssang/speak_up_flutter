import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/authentication_status_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(authenticationStatusProvider)) {
        ref
            .read(appNavigatorProvider)
            .navigateTo(AppRoutes.mainMenu, shouldClearStack: true);
      } else {
        ref
            .read(appNavigatorProvider)
            .navigateTo(AppRoutes.onboarding, shouldClearStack: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
