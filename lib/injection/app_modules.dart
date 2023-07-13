import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/data/services/preference_services/shared_preferences_manager.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_email_and_password_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_goole_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_out_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/firebase_options.dart';
import 'package:speak_up/injection/injector.dart';

class AppModules {
  static Future<void> inject() async {
    // SharedPreferences client
    injector.registerSingletonAsync<SharedPreferences>(() async {
      return SharedPreferences.getInstance();
    });

    // SharedPreferences manager
    injector.registerLazySingleton<SharedPreferencesManager>(
        () => SharedPreferencesManager(injector.get<SharedPreferences>()));

    //Firebase Auth
    injector.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    // Google Sign In
    injector.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId));

    // Cloud Storage
    injector.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance);

    // Account settings repository
    injector.registerLazySingleton<AccountSettingsRepository>(() =>
        AccountSettingsRepository(injector.get<SharedPreferencesManager>()));

    // Authentication repository
    injector.registerLazySingleton<AuthenticationRepository>(() =>
        AuthenticationRepository(
            injector.get<FirebaseAuth>(), injector.get<GoogleSignIn>()));

    // Firestore repository
    injector.registerLazySingleton<FirestoreRepository>(() =>
        FirestoreRepository(injector.get<FirebaseFirestore>()));
    // Get app theme use case
    injector
        .registerLazySingleton<GetAppThemeUseCase>(() => GetAppThemeUseCase());

    // Switch app theme use case
    injector.registerLazySingleton<SwitchAppThemeUseCase>(
        () => SwitchAppThemeUseCase());

    // Create user with email and password use case
    injector.registerLazySingleton<CreateUserWithEmailAndPasswordUseCase>(
        () => CreateUserWithEmailAndPasswordUseCase());

    // Sign in with email and password use case
    injector.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
        () => SignInWithEmailAndPasswordUseCase());

    //Sign in with google use case
    injector.registerLazySingleton<SignInWithGoogleUseCase>(
        () => SignInWithGoogleUseCase());

    // Sign out use case
    injector.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());

    // check signed in use case
    injector
        .registerLazySingleton<IsSignedInUseCase>(() => IsSignedInUseCase());

    //Get topic list from category use case
    injector.registerLazySingleton<GetTopicListFromCategoryUseCase>(
        () => GetTopicListFromCategoryUseCase());
  }
}
