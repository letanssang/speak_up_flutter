import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/authentication/get_current_user_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/is_signed_in_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_display_name_use_case.dart';
import 'package:speak_up/domain/use_cases/authentication/update_email_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/edit_profile/edit_profile_state.dart';
import 'package:speak_up/presentation/pages/edit_profile/edit_profile_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/utilities/enums/validator_type.dart';
import 'package:speak_up/presentation/utilities/error/app_error_message.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/text_fields/custom_text_field.dart';

final editProfileViewModelProvider =
    StateNotifierProvider.autoDispose<EditProfileViewModel, EditProfileState>(
        (ref) => EditProfileViewModel(
              injector.get<GetCurrentUserUseCase>(),
              injector.get<IsSignedInUseCase>(),
              injector.get<UpdateDisplayNameUseCase>(),
              injector.get<UpdateEmailUseCase>(),
            ));

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _userNameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameTextEditingController.text = user!.displayName ?? '';
    _emailTextEditingController.text = user!.email ?? '';
  }

  EditProfileViewModel get _viewModel =>
      ref.read(editProfileViewModelProvider.notifier);

  @override
  void dispose() {
    _userNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    super.dispose();
  }

  void addFetchDataListener() {
    ref.listen(
        editProfileViewModelProvider.select((value) => value.loadingStatus),
        (previous, next) {
      if (next == LoadingStatus.success) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.success,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            ),
            content: Text(
                AppLocalizations.of(context)!
                    .yourProfileInformationHasBeenUpdated,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  ref.read(appNavigatorProvider).pop();
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                    )),
              ),
            ],
          ),
        );
      }
    });
  }

  void addErrorMessageListener(BuildContext context) {
    ref.listen(editProfileViewModelProvider.select((value) => value.errorCode),
        (previous, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              getAppErrorMessage(next, context),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      _viewModel.resetError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileViewModelProvider);
    addFetchDataListener();
    addErrorMessageListener(context);
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: Text(AppLocalizations.of(context)!.personalInformation,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              )),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              width: ScreenUtil().screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: ScreenUtil().setSp(24),
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
                    validatorType: ValidatorType.userName,
                    context: context,
                  ),
                  if (user!.providerData[0].providerId == 'password')
                    CustomTextField(
                      aboveText: AppLocalizations.of(context)!.enterYourEmail,
                      suffixIcon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      validatorType: ValidatorType.email,
                      context: context,
                    ),
                  CustomButton(
                    marginVertical: ScreenUtil().setHeight(50),
                    text: AppLocalizations.of(context)!.confirmChange,
                    buttonState: state.loadingStatus.buttonState,
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      _viewModel.onSubmitted(
                          name: _userNameTextEditingController.text,
                          email: _emailTextEditingController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
