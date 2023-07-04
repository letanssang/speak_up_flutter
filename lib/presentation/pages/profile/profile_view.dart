import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/account_settings/get_app_theme_use_case.dart';
import 'package:speak_up/domain/use_cases/account_settings/switch_app_theme_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/profile/profile_state.dart';
import 'package:speak_up/presentation/pages/profile/profile_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) =>
        ProfileViewModel(injector.get<GetAppThemeUseCase>(),
            injector.get<SwitchAppThemeUseCase>()));

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Profile'),
        ),
        body: Column(
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
                  Text(
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
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildListTile(
                      AppIcons.notification(size: 48), 'Notification'),
                  buildListTile(AppIcons.darkMode(size: 48), 'Dark mode',
                      trailing: Switch(
                        value: state.isDarkMode,
                        onChanged: (value){
                          ref
                              .read(profileViewModelProvider.notifier)
                              .changeThemeData(value);
                          ref.read(themeProvider.notifier).state = value;
                        },
                      )),
                  buildListTile(AppIcons.about(size: 48), 'About'),
                  buildListTile(AppIcons.logout(size: 48), 'Logout'),
                ],
              ),
            )
          ],
        ));
  }

  Widget buildListTile(Widget icon, String title, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {},
        trailing: trailing ??
            const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
      ),
    );
  }
}
