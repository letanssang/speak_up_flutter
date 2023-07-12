import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/sign_up/sign_up_state.dart';
import 'package:speak_up/presentation/pages/sign_up/sign_up_view_model.dart';
import 'package:speak_up/presentation/utilities/common/validator.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final signUpViewModelProvider =
    StateNotifierProvider.autoDispose<SignUpViewModel, SignUpState>(
        (ref) => SignUpViewModel(
              injector.get<CreateUserWithEmailAndPasswordUseCase>(),
            ));

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  void addFetchingListener(BuildContext context) {
    ref.listen(signUpViewModelProvider.select((value) => value.loadingStatus),
        (previous, next) {
      if (next == LoadingStatus.success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Your account has been created successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  ref.read(appNavigatorProvider).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
    ref.listen(signUpViewModelProvider.select((value) => value.errorMessage),
        (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
          ),
        );
      }
      ref.read(signUpViewModelProvider.notifier).resetError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);
    addFetchingListener(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                child: const Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomTextField(
                hintText: 'Enter your user name',
                suffixIcon: const Icon(Icons.person),
                keyboardType: TextInputType.name,
                controller: _userNameTextEditingController,
                validator: validateUserName,
              ),
              CustomTextField(
                hintText: 'Enter your email address',
                suffixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                controller: _emailTextEditingController,
                validator: validateEmail,
              ),
              CustomTextField(
                hintText: 'Enter your password',
                suffixIcon: Icon(state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onSuffixIconTap: () {
                  ref
                      .read(signUpViewModelProvider.notifier)
                      .onPasswordVisibilityPressed();
                },
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordTextEditingController,
                obscureText:
                    !ref.watch(signUpViewModelProvider).isPasswordVisible,
                validator: validatePassword,
                errorMaxLines: 2,
              ),
              Center(
                  child: CustomButton(
                marginVertical: 30,
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  ref
                      .read(signUpViewModelProvider.notifier)
                      .onSignUpButtonPressed(_emailTextEditingController.text,
                          _passwordTextEditingController.text);
                },
                text: 'Continue',
                buttonState: state.loadingStatus.buttonState,
              )),
              const Center(
                child: Text(
                  'Already have an account?',
                ),
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      ref.read(appNavigatorProvider).pop();
                    },
                    child: Text('Sign in',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
