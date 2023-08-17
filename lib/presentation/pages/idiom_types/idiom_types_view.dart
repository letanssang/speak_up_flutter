import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_type_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_state.dart';
import 'package:speak_up/presentation/pages/idiom_types/idiom_types_view_model.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/learning_mode_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final idiomTypesViewModelProvider =
    StateNotifierProvider.autoDispose<IdiomTypesViewModel, IdiomTypesState>(
  (ref) => IdiomTypesViewModel(
    injector.get<GetIdiomTypeListUseCase>(),
  ),
);

class IdiomTypesView extends ConsumerStatefulWidget {
  const IdiomTypesView({super.key});

  @override
  ConsumerState<IdiomTypesView> createState() => _IdiomTypesViewState();
}

class _IdiomTypesViewState extends ConsumerState<IdiomTypesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    await ref.read(idiomTypesViewModelProvider.notifier).fetchIdiomTypeList();
  }

  void showOptionButtonSheet(int index) {
    final idiomType = ref.read(idiomTypesViewModelProvider).idiomTypes[index];
    showModalBottomSheet(
        context: context,
        builder: (context) => LearningModeBottomSheet(
              title: idiomType.name,
              onTapLecture: () {
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.idiom, arguments: idiomType);
              },
              onTapFlashcard: () {
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.flashCards, arguments: idiomType);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomTypesViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return ListView.builder(
          itemCount: state.idiomTypes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              child: Card(
                elevation: 3,
                color: isDarkTheme ? Colors.grey[850] : Colors.white,
                surfaceTintColor: Colors.white,
                child: ListTile(
                  onTap: () {
                    showOptionButtonSheet(index);
                  },
                  leading: CircleAvatar(
                      child: Text(
                    formatIndexToString(index),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  title: Text(
                    language == Language.english
                        ? state.idiomTypes[index].name
                        : state.idiomTypes[index].translation,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.play_circle_outline_outlined,
                    size: ScreenUtil().setWidth(32),
                    color: isDarkTheme
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        );
      case LoadingStatus.error:
        return Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong));
      default:
        return const Center(child: AppLoadingIndicator());
    }
  }
}
