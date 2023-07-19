import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/common/validator.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final user = FirebaseAuth.instance.currentUser;
  final _userNameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameTextEditingController.text = user!.displayName ?? '';
    _emailTextEditingController.text = user!.email ?? '';
  }

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(AppLocalizations.of(context)!.personalInformation),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: ScreenUtil().screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 32,
                    child: ClipOval(
                      child: user!.photoURL != null
                          ? Image.network(user?.photoURL! ?? '')
                          : AppImages.avatar(),
                    ),
                  ),
                ),
                CustomTextField(
                  aboveText: AppLocalizations.of(context)!.enterYourName,
                  suffixIcon: const Icon(Icons.person),
                  keyboardType: TextInputType.name,
                  controller: _userNameTextEditingController,
                  validator: validateUserName,
                ),
                CustomTextField(
                  aboveText: AppLocalizations.of(context)!.enterYourEmail,
                  suffixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextEditingController,
                  validator: validateEmail,
                ),
                CustomButton(
                  marginVertical: ScreenUtil().setHeight(50),
                  text: AppLocalizations.of(context)!.confirmChange,
                ),
              ],
            ),
          ),
        ));
  }
}
