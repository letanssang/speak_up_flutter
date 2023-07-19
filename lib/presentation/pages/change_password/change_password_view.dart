import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_state.dart';
import 'package:speak_up/presentation/pages/change_password/change_password_view_model.dart';
import 'package:speak_up/presentation/utilities/common/validator.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final changePasswordViewModelProvider = StateNotifierProvider.autoDispose<
    ChangePasswordViewModel,
    ChangePasswordState>((ref) => ChangePasswordViewModel());

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _currentPasswordTextEditingController = TextEditingController();
  final _newPasswordTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _currentPasswordTextEditingController.dispose();
    _newPasswordTextEditingController.dispose();
    _confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(AppLocalizations.of(context)!.changePassword),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              aboveText: AppLocalizations.of(context)!.currentPassword,
              keyboardType: TextInputType.visiblePassword,
              controller: _currentPasswordTextEditingController,
              errorMaxLines: 2,
              validator: validatePassword,
              obscureText: !state.isCurrentPasswordVisible,
              onSuffixIconTap: () {
                ref
                    .read(changePasswordViewModelProvider.notifier)
                    .onCurrentPasswordVisibilityPressed();
              },
              suffixIcon: Icon(state.isCurrentPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
            CustomTextField(
              aboveText: AppLocalizations.of(context)!.newPassword,
              keyboardType: TextInputType.visiblePassword,
              controller: _newPasswordTextEditingController,
              errorMaxLines: 2,
              validator: validatePassword,
              obscureText: !state.isNewPasswordVisible,
              onSuffixIconTap: () {
                ref
                    .read(changePasswordViewModelProvider.notifier)
                    .onNewPasswordVisibilityPressed();
              },
              suffixIcon: Icon(state.isNewPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
            CustomTextField(
              aboveText: AppLocalizations.of(context)!.confirmNewPassword,
              keyboardType: TextInputType.visiblePassword,
              controller: _confirmPasswordTextEditingController,
              errorMaxLines: 2,
              validator: validatePassword,
              obscureText: !state.isConfirmPasswordVisible,
              onSuffixIconTap: () {
                ref
                    .read(changePasswordViewModelProvider.notifier)
                    .onConfirmPasswordVisibilityPressed();
              },
              suffixIcon: Icon(state.isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
            CustomButton(
              marginVertical: ScreenUtil().setHeight(50),
              text: AppLocalizations.of(context)!.confirmChange,
            ),
          ],
        ),
      ),
    );
  }
}
