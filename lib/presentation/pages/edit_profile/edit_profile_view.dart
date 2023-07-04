import 'package:flutter/material.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';
class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Personal Information'),
      ),
  body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 32,
        child: ClipOval(
          child: Image.asset('assets/images/avatar.png'),
        ),
      ),
      CustomTextField(
        aboveText: 'Full Name',
        initialValue: 'Sang',
      ),
      CustomTextField(
        aboveText: 'Email',
        initialValue: 'user@email.com'
      ),
      CustomTextField(
        aboveText: 'Phone Number',
        initialValue: '0123456789'
      ),
      CustomButton(
        marginVertical: 32,
        text: 'Save', )
    ],
  ),
    );
  }
}
