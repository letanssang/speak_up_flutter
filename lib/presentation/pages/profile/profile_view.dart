import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_out_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/pages/profile/profile_state.dart';
import 'package:speak_up/presentation/pages/profile/profile_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
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
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(profileViewModelProvider.notifier).getThemeData();
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(profileViewModelProvider.notifier).signOut();
                Future.delayed(Duration(seconds: 1), () {
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
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
            },
          ),
          title: const Text('Account Settings'),
          actions: [
            IconButton(
              onPressed: () async {
                await _dialogBuilder(context);
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
                                child: AppImages.avatar(),
                              ),
                            ),
                          ),
                          const Text(
                            'Sang',
                            style: TextStyle(
                              fontSize: 24,
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
                          buildListTile(
                              AppIcons.avatar(size: 48), 'Edit profile',
                              onTap: () {
                            ref
                                .read(appNavigatorProvider)
                                .navigateTo(AppRoutes.editProfile);
                          }),
                          buildListTile(
                              AppIcons.notification(size: 48), 'Notification',
                              trailing: Switch(
                                value: state.enableNotification,
                                onChanged: (value) {
                                  ref
                                      .read(profileViewModelProvider.notifier)
                                      .switchNotification(value);
                                },
                              )),
                          buildListTile(
                              AppIcons.darkMode(size: 48), 'Dark mode',
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
                              AppIcons.changeLanguage(size: 48), 'Language',
                              trailing: Switch(
                                value: false,
                                onChanged: (value) {},
                              )),
                          buildListTile(AppIcons.about(size: 48), 'About',
                              onTap: () {
                            ref
                                .read(appNavigatorProvider)
                                .navigateTo(AppRoutes.about);
                          }),
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
