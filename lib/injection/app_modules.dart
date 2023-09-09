import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_speech/google_speech.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_up/data/local/database_services/database_manager.dart';
import 'package:speak_up/data/local/preference_services/shared_preferences_manager.dart';
import 'package:speak_up/data/remote/dictionary_client/dictionary_client.dart';
import 'package:speak_up/data/remote/youtube_client/youtube_client.dart';
import 'package:speak_up/data/repositories/account_settings/account_settings_repository.dart';
import 'package:speak_up/data/repositories/audio_player/audio_player_repository.dart';
import 'package:speak_up/data/repositories/authentication/authentication_repository.dart';
import 'package:speak_up/data/repositories/dictionary/dictionary_repository.dart';
import 'package:speak_up/data/repositories/firestore/firestore_repository.dart';
import 'package:speak_up/data/repositories/local_database/local_database_repository.dart';
import 'package:speak_up/data/repositories/record/record_repository.dart';
import 'package:speak_up/data/repositories/speech_to_text/speech_to_text_repository.dart';
import 'package:speak_up/data/repositories/text_to_speech/text_to_speech_repository.dart';
import 'package:speak_up/data/repositories/youtube_repository/youtube_repository.dart';
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
import 'package:speak_up/domain/use_cases/dictionary/get_word_detail_use_case.dart';
import 'package:speak_up/domain/use_cases/dictionary/get_word_list_from_search_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/get_youtube_playlist_id_list_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_idiom_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/update_idiom_progress_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/save_user_data_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_category_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_type_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_idiom_type_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_lesson_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phonetic_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phrasal_verb_type_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_idiom_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_pattern_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_topic_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_pattern_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_word_list_by_phonetic_id_use_case.dart';
import 'package:speak_up/domain/use_cases/record/start_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/record/stop_recording_use_case.dart';
import 'package:speak_up/domain/use_cases/speech_to_text/get_text_from_speech_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/domain/use_cases/youtube/get_youtube_playlist_by_id_use_case.dart';
import 'package:speak_up/firebase_options.dart';
import 'package:speak_up/injection/injector.dart';

import '../domain/use_cases/audio_player/pause_audio_use_case.dart';

const String audioPlayerInstanceName = 'audioPlayer';
const String slowAudioPlayerInstanceName = 'slowAudioPlayer';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('\x1B[33mRequest URL: ${options.uri.toString()}\x1B[0m');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Response Code: ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('Error: ${err.message}');
    super.onError(err, handler);
  }
}

class AppModules {
  static Future<void> inject() async {
    //Firebase
    final firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Dio
    await dotenv.load(fileName: "assets/keys/keys.env");
    final dio = Dio();
    dio.options.headers['x-rapidapi-key'] = dotenv.env['WORDS_API_KEY'];
    dio.interceptors.add(LoggingInterceptor());

    // Database Manager
    injector.registerLazySingleton<DatabaseManager>(() => DatabaseManager());

    // Dictionary client
    injector
        .registerLazySingleton<DictionaryClient>(() => DictionaryClient(dio));

    injector.registerLazySingleton<Dio>(() => dio);
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

    // Youtube Client
    injector.registerLazySingleton<YoutubeClient>(() => YoutubeClient(dio));

    // Dictionary repository
    injector.registerLazySingleton<DictionaryRepository>(
        () => DictionaryRepository(injector.get<DictionaryClient>()));

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
    String googleSpeechToTextApiKey = dotenv.env['GOOGLE_SPEECH_API_KEY']!;

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

    //Text To Speech
    injector.registerLazySingleton<FlutterTts>(() => FlutterTts());

    //Text To Speech Repository
    injector.registerLazySingleton<TextToSpeechRepository>(() {
      return TextToSpeechRepository(injector.get<FlutterTts>());
    });

    // Youtube Repository
    injector.registerLazySingleton<YoutubeRepository>(() => YoutubeRepository(
        injector.get<YoutubeClient>(), firebaseApp.options.apiKey));

    // Local Database Repository
    injector.registerLazySingleton<LocalDatabaseRepository>(
        () => LocalDatabaseRepository(injector.get<DatabaseManager>()));
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
    injector.registerLazySingleton<GetTopicListByCategoryIDUseCase>(
        () => GetTopicListByCategoryIDUseCase());

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

    // Pause audio use case
    injector
        .registerLazySingleton<PauseAudioUseCase>(() => PauseAudioUseCase());

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

    // Speak From Text Use Case
    injector.registerLazySingleton<SpeakFromTextUseCase>(
        () => SpeakFromTextUseCase());

    // Get word list from search use case
    injector.registerLazySingleton<GetWordListFromSearchUseCase>(
        () => GetWordListFromSearchUseCase());

    // Get detail word use case
    injector.registerLazySingleton<GetWordDetailUseCase>(
        () => GetWordDetailUseCase());

    // Get phonetic list use case
    injector.registerLazySingleton<GetPhoneticListUseCase>(
        () => GetPhoneticListUseCase());

    // Get youtube playlist id list use case
    injector.registerLazySingleton<GetYoutubePLayListIdListUseCase>(
        () => GetYoutubePLayListIdListUseCase());

    // Get youtube playlist by id use case
    injector.registerLazySingleton<GetYoutubePlaylistByIdUseCase>(
        () => GetYoutubePlaylistByIdUseCase());

    //Update Idiom Process Use Case
    injector.registerLazySingleton<UpdateIdiomProgressUseCase>(
        () => UpdateIdiomProgressUseCase());

    // Get Idiom Progress Use Case
    injector.registerLazySingleton<GetIdiomProgressUseCase>(
        () => GetIdiomProgressUseCase());

    //Get Word List By Phonetic ID Use Case
    injector.registerLazySingleton<GetWordListByPhoneticIDUSeCase>(
        () => GetWordListByPhoneticIDUSeCase());
  }
}
