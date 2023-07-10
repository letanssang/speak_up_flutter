import 'package:flutter/material.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

class SignInEmailView extends StatefulWidget {
  const SignInEmailView({super.key});

  @override
  State<SignInEmailView> createState() => _SignInEmailViewState();
}

class _SignInEmailViewState extends State<SignInEmailView> {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Sign in to your account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomTextField(
                aboveText: 'Email address',
                hintText: 'Enter your email address',
                suffixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                controller: _emailTextEditingController,
              ),
              CustomTextField(
                aboveText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: const Icon(Icons.remove_red_eye),
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordTextEditingController,
                errorMaxLines: 2,
              ),
              const Center(
                child: CustomButton(
                  marginVertical: 30,
                  text: 'Sign in',
                ),
              ),
            ],
          ),
        ));
  }
}
