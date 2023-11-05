import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_expression_done_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/expression_type/expression_type_state.dart';
import 'package:speak_up/presentation/pages/expression_type/expression_type_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';

final expressionTypeViewModelProvider = StateNotifierProvider.autoDispose<
    ExpressionTypeViewModel, ExpressionTypeState>(
  (ref) => ExpressionTypeViewModel(
    injector.get<GetExpressionListByTypeUseCase>(),
    injector.get<GetExpressionDoneListUseCase>(),
    injector.get<SpeakFromTextUseCase>(),
  ),
);

class ExpressionTypeView extends ConsumerStatefulWidget {
  const ExpressionTypeView({super.key});

  @override
  ConsumerState<ExpressionTypeView> createState() => _ExpressionTypeViewState();
}

class _ExpressionTypeViewState extends ConsumerState<ExpressionTypeView> {
  ExpressionType expressionType = ExpressionType.initial();

  ExpressionTypeViewModel get _viewModel =>
      ref.read(expressionTypeViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    expressionType =
        ModalRoute.of(context)!.settings.arguments as ExpressionType;
    await _viewModel.fetchExpressionList(expressionType.expressionTypeID);
    await _viewModel.fetchExpressionDoneList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expressionTypeViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: Text(expressionType.name,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              )),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                state.isTranslated
                    ? expressionType.descriptionTranslation
                    : expressionType.description,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),
            ),
            Row(
              children: [
                Flexible(child: Container()),
                CustomIconButton(
                  height: ScreenUtil().setHeight(40),
                  width: ScreenUtil().setWidth(40),
                  icon: Icon(
                    Icons.volume_up_outlined,
                    size: ScreenUtil().setWidth(18),
                  ),
                  onPressed: () {
                    _viewModel.speak(expressionType.description);
                  },
                ),
                CustomIconButton(
                    height: ScreenUtil().setHeight(40),
                    width: ScreenUtil().setWidth(40),
                    icon: Icon(
                      Icons.translate_outlined,
                      size: ScreenUtil().setWidth(18),
                    ),
                    onPressed: _viewModel.toggleTranslate),
                Flexible(child: Container()),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: state.expressions.length,
              itemBuilder: (context, index) {
                return AppListTile(
                  index: index,
                  onTap: () {
                    ref.read(appNavigatorProvider).navigateTo(
                          AppRoutes.expression,
                          arguments: state.expressions[index],
                        );
                  },
                  title: state.expressions[index].name,
                  subtitle: state.expressions[index].translation,
                  trailing:
                      state.progressLoadingStatus == LoadingStatus.success &&
                              state.isDoneList[index]
                          ? Icon(
                              Icons.check_outlined,
                              size: ScreenUtil().setWidth(24),
                              color: isDarkTheme
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            )
                          : null,
                );
              },
            ),
          ],
        ));
  }
}
