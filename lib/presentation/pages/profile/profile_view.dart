import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/save_app_language_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_out_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/pages/profile/profile_state.dart';
import 'package:speak_up/presentation/pages/profile/profile_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final profileViewModelProvider =
    StateNotifierProvider.autoDispose<ProfileViewModel, ProfileState>((ref) =>
        ProfileViewModel(
            injector.get<GetAppThemeUseCase>(),
            injector.get<SwitchAppThemeUseCase>(),
            injector.get<SignOutUseCase>()));

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfileViewState();
}

class ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(profileViewModelProvider.notifier).getThemeData();
    });
  }

  Future<void> _buildLogoutDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.logOut),
          content: Text(
            AppLocalizations.of(context)!.areYouSureYouWantToLogOut,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16.0),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                AppLocalizations.of(context)!.yes,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(profileViewModelProvider.notifier).signOut();
                Future.delayed(const Duration(seconds: 1), () {
                  ref
                      .read(appNavigatorProvider)
                      .navigateTo(AppRoutes.onboarding, shouldClearStack: true);
                });
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(AppLocalizations.of(context)!.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onTapChangeLanguage(WidgetRef ref) async {
    switch (await showDialog<Language>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(AppLocalizations.of(context)!.selectLanguage),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Language.english);
                },
                child: ListTile(
                    leading: AppImages.usFlag(),
                    title: Text(Language.english.toLanguageString())),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Language.vietnamese);
                },
                child: ListTile(
                    leading: AppImages.vnFlag(),
                    title: Text(Language.vietnamese.toLanguageString())),
              ),
            ],
          );
        })) {
      case Language.english:
        ref.read(appLanguageProvider.notifier).state = Language.english;
        break;
      case Language.vietnamese:
        ref.read(appLanguageProvider.notifier).state = Language.vietnamese;
        break;
      case null:
        // dialog dismissed
        break;
    }
    injector
        .get<SaveAppLanguageUseCase>()
        .run(ref.read(appLanguageProvider.notifier).state);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
            },
          ),
          title: Text(AppLocalizations.of(context)!.accountSettings),
          actions: [
            IconButton(
              onPressed: () async {
                await _buildLogoutDialogBuilder(context);
              },
              icon: const Icon(Icons.logout, color: Colors.red, size: 24.0),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: ScreenUtil().screenHeight * 0.9,
                width: ScreenUtil().screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              radius: 32,
                              child: ClipOval(
                                child: user!.photoURL != null
                                    ? Image.network(user.photoURL!)
                                    : AppImages.avatar(),
                              ),
                            ),
                          ),
                          Text(
                            user.displayName ?? '',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildListTile(AppIcons.avatar(size: 48),
                              AppLocalizations.of(context)!.editProfile,
                              onTap: () {
                            ref
                                .read(appNavigatorProvider)
                                .navigateTo(AppRoutes.editProfile);
                          }),
                          if (user.providerData[0].providerId == 'password')
                            buildListTile(AppIcons.changePassword(size: 48),
                                AppLocalizations.of(context)!.changePassword,
                                onTap: () {
                              ref
                                  .read(appNavigatorProvider)
                                  .navigateTo(AppRoutes.changePassword);
                            }),
                          buildListTile(AppIcons.notification(size: 48),
                              AppLocalizations.of(context)!.notification,
                              trailing: Switch(
                                value: state.enableNotification,
                                onChanged: (value) {
                                  ref
                                      .read(profileViewModelProvider.notifier)
                                      .switchNotification(value);
                                },
                              )),
                          buildListTile(AppIcons.darkMode(size: 48),
                              AppLocalizations.of(context)!.darkMode,
                              trailing: Switch(
                                value: state.isDarkMode,
                                onChanged: (value) {
                                  ref
                                      .read(profileViewModelProvider.notifier)
                                      .changeThemeData(value);
                                  ref.read(themeProvider.notifier).state =
                                      value;
                                },
                              )),
                          buildListTile(
                            AppIcons.changeLanguage(size: 48),
                            AppLocalizations.of(context)!.language,
                            trailing: ref.watch(appLanguageProvider) ==
                                    Language.english
                                ? AppImages.usFlag()
                                : AppImages.vnFlag(),
                            onTap: () {
                              _onTapChangeLanguage(ref);
                              injector.get<SaveAppLanguageUseCase>().run(
                                  ref.read(appLanguageProvider.notifier).state);
                            },
                          ),
                          buildListTile(AppIcons.about(size: 48),
                              AppLocalizations.of(context)!.about, onTap: () {
                            ref
                                .read(appNavigatorProvider)
                                .navigateTo(AppRoutes.about);
                          }),
                          buildListTile(
                            AppIcons.logout(size: 46),
                            AppLocalizations.of(context)!.logOut,
                            onTap: () async {
                              await _buildLogoutDialogBuilder(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (state.isSigningOut) const AppLoadingIndicator(),
          ],
        ));
  }

  Widget buildListTile(Widget icon, String title,
      {Widget? trailing, Function()? onTap}) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        onTap: onTap,
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
      ),
    );
  }
}
