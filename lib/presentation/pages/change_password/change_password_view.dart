import 'package:flutter/material.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';
class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Change Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            aboveText: 'Current Password',
          ),
          CustomTextField(
              aboveText: 'New Password',
          ),
          CustomTextField(
              aboveText: 'Confirm Password',
          ),
          CustomButton(
            marginVertical: 32,
            text: 'Save', )
        ],
      ),
    );
  }
}
