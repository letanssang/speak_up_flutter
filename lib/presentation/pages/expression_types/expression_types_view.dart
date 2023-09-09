import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_type_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/expression_types/expression_types_state.dart';
import 'package:speak_up/presentation/pages/expression_types/expression_types_view_model.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final expressionTypesViewModelProvider = StateNotifierProvider.autoDispose<
    ExpressionTypesViewModel, ExpressionTypesState>(
  (ref) => ExpressionTypesViewModel(
    injector.get<GetExpressionTypeListUseCase>(),
  ),
);

class ExpressionTypesView extends ConsumerStatefulWidget {
  const ExpressionTypesView({super.key});

  @override
  ConsumerState<ExpressionTypesView> createState() =>
      _ExpressionTypesViewState();
}

class _ExpressionTypesViewState extends ConsumerState<ExpressionTypesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    await ref
        .read(expressionTypesViewModelProvider.notifier)
        .fetchExpressionTypeList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expressionTypesViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return ListView.builder(
          itemCount: state.expressionTypes.length,
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
                    Navigator.of(context).pushNamed(
                      AppRoutes.expression,
                      arguments: state.expressionTypes[index],
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
                  title: Text(
                    state.expressionTypes[index].name,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    state.expressionTypes[index].translation,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
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
        return const AppErrorView();
      default:
        return const Center(child: AppLoadingIndicator());
    }
  }
}
