import 'package:flutter/material.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/about/about_view.dart';
import 'package:speak_up/presentation/pages/categories/categories_view.dart';
import 'package:speak_up/presentation/pages/category/category_view.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_view.dart';
import 'package:speak_up/presentation/pages/common_word_type/common_word_type_view.dart';
import 'package:speak_up/presentation/pages/edit_profile/edit_profile_view.dart';
import 'package:speak_up/presentation/pages/expression/expression_view.dart';
import 'package:speak_up/presentation/pages/expression_type/expression_type_view.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_view.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_view.dart';
import 'package:speak_up/presentation/pages/lesson/lesson_view.dart';
import 'package:speak_up/presentation/pages/lessons/lessons_view.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/pages/onboarding/onboarding_view.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_view.dart';
import 'package:speak_up/presentation/pages/phonetic/phonetic_view.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_view.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_view.dart';
import 'package:speak_up/presentation/pages/pronunciation_practice/pronunciation_practice_view.dart';
import 'package:speak_up/presentation/pages/pronunciation_topic/pronunciation_topic_view.dart';
import 'package:speak_up/presentation/pages/quiz/quiz_view.dart';
import 'package:speak_up/presentation/pages/reels/reels_view.dart';
import 'package:speak_up/presentation/pages/sign_in/sign_in_view.dart';
import 'package:speak_up/presentation/pages/sign_in_email/sign_in_email_view.dart';
import 'package:speak_up/presentation/pages/sign_up/sign_up_view.dart';
import 'package:speak_up/presentation/pages/splash/splash_view.dart';
import 'package:speak_up/presentation/pages/tense/tense_view.dart';
import 'package:speak_up/presentation/pages/topic/topic_view.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    debugPrint('Navigation: ${settings.name}');
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
          settings: settings,
        );
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
      case AppRoutes.topic:
        {
          return MaterialPageRoute(
            builder: (context) => const TopicView(),
            settings: settings,
          );
        }
      case AppRoutes.lessons:
        {
          return MaterialPageRoute(
            builder: (context) => const LessonsView(),
            settings: settings,
          );
        }
      case AppRoutes.lesson:
        {
          return MaterialPageRoute(
            builder: (context) => const LessonView(),
            settings: settings,
          );
        }
      case AppRoutes.pattern:
        {
          return MaterialPageRoute(
            builder: (context) => const PatternView(),
            settings: settings,
          );
        }
      case AppRoutes.expressionType:
        {
          return MaterialPageRoute(
            builder: (context) => const ExpressionTypeView(),
            settings: settings,
          );
        }
      case AppRoutes.phrasalVerb:
        {
          return MaterialPageRoute(
            builder: (context) => const PhrasalVerbView(),
            settings: settings,
          );
        }
      case AppRoutes.idiom:
        {
          return MaterialPageRoute(
            builder: (context) => const IdiomView(),
            settings: settings,
          );
        }

      case AppRoutes.flashCards:
        {
          return MaterialPageRoute(
            builder: (context) => const FlashCardsView(),
            settings: settings,
          );
        }
      case AppRoutes.quiz:
        {
          return MaterialPageRoute(
            builder: (context) => const QuizView(),
            settings: settings,
          );
        }
      case AppRoutes.phonetic:
        {
          return MaterialPageRoute(
            builder: (context) => const PhoneticView(),
            settings: settings,
          );
        }
      case AppRoutes.reels:
        {
          return MaterialPageRoute(
            builder: (context) => const ReelsView(),
            settings: settings,
          );
        }
      case AppRoutes.pronunciation:
        {
          return MaterialPageRoute(
            builder: (context) => const PronunciationView(),
            settings: settings,
          );
        }

      case AppRoutes.expression:
        {
          return MaterialPageRoute(
            builder: (context) => const ExpressionView(),
            settings: settings,
          );
        }

      case AppRoutes.commonWordType:
        {
          return MaterialPageRoute(
            builder: (context) => const CommonWordTypeView(),
            settings: settings,
          );
        }

      case AppRoutes.tense:
        {
          return MaterialPageRoute(
            builder: (context) => const TenseView(),
            settings: settings,
          );
        }
      case AppRoutes.pronunciationPractice:
        {
          return MaterialPageRoute(
            builder: (context) => const PronunciationPracticeView(),
            settings: settings,
          );
        }
      case AppRoutes.pronunciationTopic:
        {
          return MaterialPageRoute(
            builder: (context) => const PronunciationTopicView(),
            settings: settings,
          );
        }
      default:
        return null;
    }
  }
}
