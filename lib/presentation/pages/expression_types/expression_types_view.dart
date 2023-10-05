import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_expression_type_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/expression_types/expression_types_state.dart';
import 'package:speak_up/presentation/pages/expression_types/expression_types_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
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
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return _buildLoadingSuccessBody(state);
      case LoadingStatus.error:
        return const AppErrorView();
      default:
        return const AppLoadingIndicator();
    }
  }

  ListView _buildLoadingSuccessBody(ExpressionTypesState state) {
    return ListView.builder(
      itemCount: state.expressionTypes.length,
      itemBuilder: (context, index) {
        return AppListTile(
          index: index,
          title: state.expressionTypes[index].name,
          subtitle: state.expressionTypes[index].translation,
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.expressionType,
              arguments: state.expressionTypes[index],
            );
          },
        );
      },
    );
  }
}
