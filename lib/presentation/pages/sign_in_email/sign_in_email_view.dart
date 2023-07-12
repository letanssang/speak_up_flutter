import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/sign_in_with_email_and_password_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/sign_in_email/sign_in_email_state.dart';
import 'package:speak_up/presentation/pages/sign_in_email/sign_in_view_model.dart';
import 'package:speak_up/presentation/utilities/common/validator.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final signInEmailViewModelProvider =
    StateNotifierProvider.autoDispose<SignInEmailViewModel, SignInEmailState>(
        (ref) => SignInEmailViewModel(
              injector.get<SignInWithEmailAndPasswordUseCase>(),
            ));

class SignInEmailView extends ConsumerStatefulWidget {
  const SignInEmailView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignInEmailViewState();
}

class _SignInEmailViewState extends ConsumerState<SignInEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  void addFetchDataListener() {
    ref.listen(
        signInEmailViewModelProvider.select((value) => value.loadingStatus),
        (previous, next) {
      if (next == LoadingStatus.success) {
        ref.read(appNavigatorProvider).navigateTo(
              AppRoutes.mainMenu,
              shouldClearStack: true,
            );
      }
    });
    ref.listen(
        signInEmailViewModelProvider.select((value) => value.errorMessage),
        (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
          ),
        );
      }
      ref.read(signInEmailViewModelProvider.notifier).resetError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInEmailViewModelProvider);
    addFetchDataListener();
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  validator: validateEmail,
                ),
                CustomTextField(
                  aboveText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: const Icon(Icons.remove_red_eye),
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordTextEditingController,
                  errorMaxLines: 2,
                  validator: validatePassword,
                  obscureText: !state.isPasswordVisible,
                  onSuffixIconTap: () {
                    ref
                        .read(signInEmailViewModelProvider.notifier)
                        .onPasswordVisibilityPressed();
                  },
                ),
                Center(
                  child: CustomButton(
                      marginVertical: 30,
                      text: 'Sign in',
                      buttonState: state.loadingStatus.buttonState,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        ref
                            .read(signInEmailViewModelProvider.notifier)
                            .onSignInButtonPressed(
                                _emailTextEditingController.text,
                                _passwordTextEditingController.text);
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
