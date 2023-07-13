import 'package:flutter/material.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/about/about_view.dart';
import 'package:speak_up/presentation/pages/categories/categories_view.dart';
import 'package:speak_up/presentation/pages/category/category_view.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_view.dart';
import 'package:speak_up/presentation/pages/edit_profile/edit_profile_view.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/pages/onboarding/onboarding_view.dart';
import 'package:speak_up/presentation/pages/sign_in/sign_in_view.dart';
import 'package:speak_up/presentation/pages/sign_in_email/sign_in_email_view.dart';
import 'package:speak_up/presentation/pages/sign_up/sign_up_view.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint('Navigation: ${settings.name}');
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (context) => const OnboardingView(),
          settings: settings,
        );
      case AppRoutes.mainMenu:
        return MaterialPageRoute(
          builder: (context) => const MainMenuView(),
          settings: settings,
        );
      case AppRoutes.signIn:
        {
          return MaterialPageRoute(
            builder: (context) => const SignInView(),
            settings: settings,
          );
        }
      case AppRoutes.signInEmail:
        {
          return MaterialPageRoute(
            builder: (context) => const SignInEmailView(),
            settings: settings,
          );
        }
      case AppRoutes.signUpEmail:
        {
          return MaterialPageRoute(
            builder: (context) => const SignUpView(),
            settings: settings,
          );
        }
      case AppRoutes.editProfile:
        {
          return MaterialPageRoute(
            builder: (context) => const EditProfileView(),
            settings: settings,
          );
        }
      case AppRoutes.changePassword:
        {
          return MaterialPageRoute(
            builder: (context) => const ChangePasswordView(),
            settings: settings,
          );
        }
      case AppRoutes.about:
        {
          return MaterialPageRoute(
            builder: (context) => const AboutView(),
            settings: settings,
          );
        }
      case AppRoutes.categories:
        {
          return MaterialPageRoute(
            builder: (context) => const CategoriesView(),
            settings: settings,
          );
        }
      case AppRoutes.category:
        {
          return MaterialPageRoute(
            builder: (context) => const CategoryView(),
            settings: settings,
          );
        }
      default:
        return null;
    }
  }
}
