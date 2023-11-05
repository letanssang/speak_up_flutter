import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/reauthenticate_with_credential_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_password_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_state.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/validator_type.dart';
import 'package:speak_up/presentation/utilities/error/app_error_message.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final changePasswordViewModelProvider = StateNotifierProvider.autoDispose<
        ChangePasswordViewModel, ChangePasswordState>(
    (ref) => ChangePasswordViewModel(
          injector.get<IsSignedInUseCase>(),
          injector.get<UpdatePasswordUseCase>(),
          injector.get<ReAuthenticateWithCredentialUseCase>(),
        ));

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordTextEditingController = TextEditingController();
  final _newPasswordTextEditingController = TextEditingController();

  ChangePasswordViewModel get _viewModel =>
      ref.read(changePasswordViewModelProvider.notifier);

  @override
  void dispose() {
    _currentPasswordTextEditingController.dispose();
    _newPasswordTextEditingController.dispose();
    super.dispose();
  }

  void addFetchDataListener() {
    ref.listen(
        changePasswordViewModelProvider.select((value) => value.loadingStatus),
        (previous, next) {
      if (next == LoadingStatus.success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Your password has been changed successfully'),
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
  }

  void addErrorMessageListener(BuildContext context) {
    ref.listen(
        changePasswordViewModelProvider.select((value) => value.errorCode),
        (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getAppErrorMessage(next, context)),
            backgroundColor: Colors.red,
          ),
        );
      }
      _viewModel.resetError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordViewModelProvider);
    addFetchDataListener();
    addErrorMessageListener(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(
          AppLocalizations.of(context)!.changePassword,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                aboveText: AppLocalizations.of(context)!.currentPassword,
                keyboardType: TextInputType.visiblePassword,
                controller: _currentPasswordTextEditingController,
                errorMaxLines: 2,
                validatorType: ValidatorType.password,
                context: context,
                obscureText: !state.isPasswordVisible,
                onSuffixIconTap: _viewModel.onPasswordVisibilityPressed,
                suffixIcon: Icon(state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              CustomTextField(
                aboveText: AppLocalizations.of(context)!.newPassword,
                keyboardType: TextInputType.visiblePassword,
                controller: _newPasswordTextEditingController,
                errorMaxLines: 2,
                validatorType: ValidatorType.password,
                context: context,
                obscureText: !state.isPasswordVisible,
                onSuffixIconTap: _viewModel.onPasswordVisibilityPressed,
                suffixIcon: Icon(state.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
              CustomButton(
                  marginVertical: ScreenUtil().setHeight(50),
                  text: AppLocalizations.of(context)!.confirmChange,
                  buttonState: state.loadingStatus.buttonState,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _viewModel.onSubmitted(
                        _currentPasswordTextEditingController.text,
                        _newPasswordTextEditingController.text,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
