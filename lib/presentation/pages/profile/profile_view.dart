import 'package:flutter/material.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/resources/app_images.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
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
                        value: true,
                        onChanged: (bool value) {},
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
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
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