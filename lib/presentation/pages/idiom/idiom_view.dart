import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_state.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_view_model.dart';

final idiomViewModelProvider =
    StateNotifierProvider.autoDispose<IdiomViewModel, IdiomState>(
  (ref) => IdiomViewModel(
    injector.get<GetIdiomListByTypeUseCase>(),
  ),
);

class IdiomView extends ConsumerStatefulWidget {
  const IdiomView({super.key});

  @override
  ConsumerState<IdiomView> createState() => _IdiomViewState();
}

class _IdiomViewState extends ConsumerState<IdiomView> {
  IdiomType idiomType = IdiomType.initial();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    idiomType = ModalRoute.of(context)!.settings.arguments as IdiomType;
    await ref
        .read(idiomViewModelProvider.notifier)
        .fetchIdiomList(idiomType.idiomTypeID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(idiomType.name),
      ),
      body: Column(
        children: [
          const Text('Examples'),
          ...ref.watch(idiomViewModelProvider).idioms.map((e) => Text(e.name)),
        ],
      ),
    );
  }
}
