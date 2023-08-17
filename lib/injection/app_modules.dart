import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_speech/google_speech.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/data/repositories/audio_player/audio_player_repository.dart';
import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/cloud_store/firestore_repository.dart';
import 'package:speak_up/data/repositories/record/record_repository.dart';
import 'package:speak_up/data/repositories/speech_to_text/speech_to_text_repository.dart';
import 'package:speak_up/data/services/google_speech/google_speech_helper.dart';
import 'package:speak_up/data/services/preference_services/shared_preferences_manager.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_language_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/save_app_language_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_asset_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_file_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_slow_audio_from_url_use_case.dart';
import 'package:speak_up/domain/use_cases/audio_player/stop_audio_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/reauthenticate_with_credential_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_email_and_password_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_google_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_out_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_display_name_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_email_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_password_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_category_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_expression_type_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_type_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_lesson_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phrasal_verb_type_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_idiom_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_pattern_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/domain/use_cases/cloud_store/save_user_data_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/firebase_options.dart';
import 'package:speak_up/injection/injector.dart';

const String audioPlayerInstanceName = 'audioPlayer';
const String slowAudioPlayerInstanceName = 'slowAudioPlayer';

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

    // Audio Player
    injector.registerLazySingleton<AudioPlayer>(() => AudioPlayer(),
        instanceName: audioPlayerInstanceName);

    // Slow Audio Player
    injector.registerLazySingleton<AudioPlayer>(() => AudioPlayer(),
        instanceName: slowAudioPlayerInstanceName);

    //Record
    injector.registerLazySingleton<Record>(() => Record());

    // Account settings repository
    injector.registerLazySingleton<AccountSettingsRepository>(() =>
        AccountSettingsRepository(injector.get<SharedPreferencesManager>()));

    // Authentication repository
    injector.registerLazySingleton<AuthenticationRepository>(() =>
        AuthenticationRepository(
            injector.get<FirebaseAuth>(), injector.get<GoogleSignIn>()));

    // Firestore repository
    injector.registerLazySingleton<FirestoreRepository>(
        () => FirestoreRepository(injector.get<FirebaseFirestore>()));

    // Audio Player Repository
    injector.registerLazySingleton<AudioPlayerRepository>(() =>
        AudioPlayerRepository(
          injector.get<AudioPlayer>(instanceName: audioPlayerInstanceName),
          injector.get<AudioPlayer>(instanceName: slowAudioPlayerInstanceName),
        ));

    // Record repository
    injector.registerLazySingleton<RecordRepository>(
        () => RecordRepository(injector.get<Record>()));

    // Google Speech Service Account
    String googleSpeechToTextApiKey =
        (await rootBundle.loadString(googleSpeechAssetKeyPath));

    injector.registerLazySingleton<ServiceAccount>(() {
      return ServiceAccount.fromString(googleSpeechToTextApiKey);
    });

    //Speech To Text
    injector.registerLazySingleton<SpeechToText>(() {
      return SpeechToText.viaServiceAccount(injector.get<ServiceAccount>());
    });

    //Speech To Text Repository
    injector.registerLazySingleton<SpeechToTextRepository>(() {
      return SpeechToTextRepository(injector.get<SpeechToText>());
    });

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

    // ReAuthenticate with credential use case
    injector.registerLazySingleton<ReAuthenticateWithCredentialUseCase>(
        () => ReAuthenticateWithCredentialUseCase());

    // Update password use case
    injector.registerLazySingleton<UpdatePasswordUseCase>(
        () => UpdatePasswordUseCase());

    // Update email use case
    injector
        .registerLazySingleton<UpdateEmailUseCase>(() => UpdateEmailUseCase());

    //Update Display Name Use Case
    injector.registerLazySingleton<UpdateDisplayNameUseCase>(
        () => UpdateDisplayNameUseCase());

    // Get current user use case
    injector.registerLazySingleton<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase());

    // Get category list use case
    injector.registerLazySingleton<GetCategoryListUseCase>(
        () => GetCategoryListUseCase());

    // Get lesson list use case
    injector.registerLazySingleton<GetLessonListUseCase>(
        () => GetLessonListUseCase());

    // Get expression type list use case
    injector.registerLazySingleton<GetExpressionTypeListUseCase>(
        () => GetExpressionTypeListUseCase());

    // Get phrasal verb type list use case
    injector.registerLazySingleton<GetPhrasalVerbTypeListUseCase>(
        () => GetPhrasalVerbTypeListUseCase());

    //Get topic list from category use case
    injector.registerLazySingleton<GetTopicListFromCategoryUseCase>(
        () => GetTopicListFromCategoryUseCase());

    // Get expression list by type use case
    injector.registerLazySingleton<GetExpressionListByTypeUseCase>(
        () => GetExpressionListByTypeUseCase());

    // Get phrasal verb list by type use case
    injector.registerLazySingleton<GetPhrasalVerbListByTypeUseCase>(
        () => GetPhrasalVerbListByTypeUseCase());

    // Get idiom list by type use case
    injector.registerLazySingleton<GetIdiomListByTypeUseCase>(
        () => GetIdiomListByTypeUseCase());

    // Get sentence list from topic use case
    injector.registerLazySingleton<GetSentenceListFromTopicUseCase>(
        () => GetSentenceListFromTopicUseCase());

    // Get sentence pattern list use case
    injector.registerLazySingleton<GetSentencePatternListUseCase>(
        () => GetSentencePatternListUseCase());
    // Get sentence list from pattern use case
    injector.registerLazySingleton<GetSentenceListFromPatternUseCase>(
        () => GetSentenceListFromPatternUseCase());

    // Get sentence list from idiom use case
    injector.registerLazySingleton<GetSentenceListFromIdiomUseCase>(
        () => GetSentenceListFromIdiomUseCase());

    // Get idiom type list use case
    injector.registerLazySingleton<GetIdiomTypeListUseCase>(
        () => GetIdiomTypeListUseCase());

    // Save user data use case
    injector.registerLazySingleton<SaveUserDataUseCase>(
        () => SaveUserDataUseCase());

    // Get app language use case
    injector.registerLazySingleton<GetAppLanguageUseCase>(
        () => GetAppLanguageUseCase());

    // Save app language use case
    injector.registerLazySingleton<SaveAppLanguageUseCase>(
        () => SaveAppLanguageUseCase());

    // Play audio from url use case
    injector.registerLazySingleton<PlayAudioFromUrlUseCase>(
        () => PlayAudioFromUrlUseCase());

    // Play slow audio from url use case
    injector.registerLazySingleton<PlaySlowAudioFromUrlUseCase>(
        () => PlaySlowAudioFromUrlUseCase());

    //Play audio from asset use case
    injector.registerLazySingleton<PlayAudioFromAssetUseCase>(
        () => PlayAudioFromAssetUseCase());

    //Play audio from file use case
    injector.registerLazySingleton<PlayAudioFromFileUseCase>(
        () => PlayAudioFromFileUseCase());

    // Stop audio use case
    injector.registerLazySingleton<StopAudioUseCase>(() => StopAudioUseCase());

    // Start recording use case
    injector.registerLazySingleton<StartRecordingUseCase>(
        () => StartRecordingUseCase());

    //Stop recording use case
    injector.registerLazySingleton<StopRecordingUseCase>(
        () => StopRecordingUseCase());

    // Get Text From Speech Use Case
    injector.registerLazySingleton<GetTextFromSpeechUseCase>(
        () => GetTextFromSpeechUseCase());
  }
}
