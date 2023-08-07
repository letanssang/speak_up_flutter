import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/expression_type/expression_type.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_expression_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/expression/expression_state.dart';
import 'package:speak_up/presentation/pages/expression/expression_view_model.dart';

final expressionViewModelProvider =
    StateNotifierProvider.autoDispose<ExpressionViewModel, ExpressionState>(
  (ref) => ExpressionViewModel(
    injector.get<GetExpressionListByTypeUseCase>(),
  ),
);

class ExpressionView extends ConsumerStatefulWidget {
  const ExpressionView({super.key});

  @override
  ConsumerState<ExpressionView> createState() => _ExpressionViewState();
}

class _ExpressionViewState extends ConsumerState<ExpressionView> {
  ExpressionType expressionType = ExpressionType.initial();
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
        .read(expressionViewModelProvider.notifier)
        .fetchExpressionList(expressionType.expressionTypeID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expressionViewModelProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(expressionType.name),
        ),
        body: Column(
          children: [
            const Text('Examples'),
            ...state.expressions
                .map((e) => Text('${e.name} - ${e.translation}')),
          ],
        ));
  }
}
