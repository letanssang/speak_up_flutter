import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/create_user_with_email_and_password_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_display_name_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/save_user_data_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/sign_up/sign_up_state.dart';
import 'package:speak_up/presentation/pages/sign_up/sign_up_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/validator_type.dart';
import 'package:speak_up/presentation/utilities/error/app_error_message.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final signUpViewModelProvider =
    StateNotifierProvider.autoDispose<SignUpViewModel, SignUpState>(
        (ref) => SignUpViewModel(
              injector.get<CreateUserWithEmailAndPasswordUseCase>(),
              injector.get<SaveUserDataUseCase>(),
              injector.get<UpdateDisplayNameUseCase>(),
              injector.get<FirebaseAuth>(),
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
            title: Text(AppLocalizations.of(context)!.success),
            content: Text(AppLocalizations.of(context)!
                .yourAccountHasBeenCreatedSuccessfully),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  ref.read(appNavigatorProvider).navigateTo(
                        AppRoutes.mainMenu,
                        shouldClearStack: true,
                      );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void addErrorMessageListener(BuildContext context) {
    ref.listen(signUpViewModelProvider.select((value) => value.errorCode),
        (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getAppErrorMessage(next, context)),
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
    addErrorMessageListener(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppImages.signUp(
                width: ScreenUtil().screenWidth * 0.4,
                boxFit: BoxFit.fitWidth,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    child: Text(
                      textAlign: TextAlign.left,
                      AppLocalizations.of(context)!.createYourAccount,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.enterYourName,
                suffixIcon: const Icon(Icons.person),
                keyboardType: TextInputType.name,
                controller: _userNameTextEditingController,
                validatorType: ValidatorType.userName,
                context: context,
              ),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.enterYourEmail,
                suffixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                controller: _emailTextEditingController,
                validatorType: ValidatorType.email,
                context: context,
              ),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.enterYourPassword,
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
                validatorType: ValidatorType.password,
                errorMaxLines: 2,
                context: context,
              ),
              CustomButton(
                marginVertical: ScreenUtil().setHeight(16),
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  ref
                      .read(signUpViewModelProvider.notifier)
                      .onSignUpButtonPressed(
                          _emailTextEditingController.text,
                          _passwordTextEditingController.text,
                          _userNameTextEditingController.text);
                },
                text: AppLocalizations.of(context)!.continueButton,
                buttonState: state.loadingStatus.buttonState,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.alreadyHaveAnAccount,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      ref.read(appNavigatorProvider).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.signIn,
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
