import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/sign_up_email/sign_up_email_state.dart';
import 'package:speak_up/presentation/pages/sign_up_email/sign_up_email_view_model.dart';
import 'package:speak_up/presentation/utilities/common/validator.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final signUpEmailViewModelProvider =
    StateNotifierProvider.autoDispose<SignUpEmailViewModel, SignUpEmailState>(
        (ref) => SignUpEmailViewModel(
          injector.get<CreateUserWithEmailAndPasswordUseCase>(),
        ));

class SignUpEmailView extends ConsumerStatefulWidget {
  const SignUpEmailView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpEmailViewState();
}

class _SignUpEmailViewState extends ConsumerState<SignUpEmailView> {
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

  void addTextEditingListener() {
    _userNameTextEditingController.addListener(() {
      ref
          .read(signUpEmailViewModelProvider.notifier)
          .onUserNameChanged(_userNameTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      ref
          .read(signUpEmailViewModelProvider.notifier)
          .onPasswordChanged(_passwordTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      ref
          .read(signUpEmailViewModelProvider.notifier)
          .onEmailChanged(_emailTextEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpEmailViewModelProvider);
    addTextEditingListener();

    ref.listen(signUpEmailViewModelProvider.select((value) => value.errorMessage), (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
          ),
        );
      }
      ref.read(signUpEmailViewModelProvider.notifier).resetError();
    });
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
                suffixIcon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onSuffixIconTap: () {
                  ref
                      .read(signUpEmailViewModelProvider.notifier)
                      .onPasswordVisibilityPressed();
                },
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordTextEditingController,
                obscureText:
                    !ref.watch(signUpEmailViewModelProvider).isPasswordVisible,
                validator: validatePassword,
                errorMaxLines: 2,
              ),
              Center(
                  child: CustomButton(
                marginVertical: 30,
                onTap: () {
                  ref
                      .read(signUpEmailViewModelProvider.notifier)
                      .onSignUpButtonPressed(_formKey);
                },
                text: 'Continue',
                    buttonState: state.loadingStatus.buttonState,
              )),
              Center(
                child: Text(
                  'Already have an account?',
                ),
              ),
              Center(
                child: TextButton(onPressed: (){
                  ref.read(appNavigatorProvider).navigateTo(AppRoutes.signIn);
                }, child: Text('Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                ),)
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
