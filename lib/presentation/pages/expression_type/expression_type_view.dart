import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/expression_type/expression_type_state.dart';
import 'package:speak_up/presentation/pages/expression_type/expression_type_view_model.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';

final expressionTypeViewModelProvider = StateNotifierProvider.autoDispose<
    ExpressionTypeViewModel, ExpressionTypeState>(
  (ref) => ExpressionTypeViewModel(
    injector.get<GetExpressionListByTypeUseCase>(),
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
    await ref
        .read(expressionTypeViewModelProvider.notifier)
        .fetchExpressionList(expressionType.expressionTypeID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expressionTypeViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: Text(expressionType.name),
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
                  height: 40,
                  width: 40,
                  icon: Icon(
                    Icons.volume_up_outlined,
                    color: Colors.grey[800],
                  ),
                  onPressed: () {
                    _viewModel.speak(expressionType.description);
                  },
                ),
                CustomIconButton(
                    height: 40,
                    width: 40,
                    icon: Icon(
                      Icons.translate_outlined,
                      color: Colors.grey[800],
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
                return Card(
                  elevation: 3,
                  color: isDarkTheme ? Colors.grey[850] : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: ListTile(
                    onTap: () {
                      ref.read(appNavigatorProvider).navigateTo(
                            AppRoutes.expression,
                            arguments: state.expressions[index],
                          );
                    },
                    leading: CircleAvatar(
                        child: Text(
                      formatIndexToString(index),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    title: Text(state.expressions[index].name),
                    subtitle: Text(state.expressions[index].translation),
                    trailing: Icon(
                      Icons.play_circle_outline_outlined,
                      size: ScreenUtil().setWidth(32),
                      color: isDarkTheme
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
