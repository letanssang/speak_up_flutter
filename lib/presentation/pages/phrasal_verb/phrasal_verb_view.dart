import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/phrasal_verb_type/phrasal_verb_type.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phrasal_verb_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_state.dart';
import 'package:speak_up/presentation/pages/phrasal_verb/phrasal_verb_view_model.dart';

final phrasalVerbViewModelProvider =
    StateNotifierProvider.autoDispose<PhrasalVerbViewModel, PhrasalVerbState>(
  (ref) => PhrasalVerbViewModel(
    injector.get<GetPhrasalVerbListByTypeUseCase>(),
  ),
);

class PhrasalVerbView extends ConsumerStatefulWidget {
  const PhrasalVerbView({super.key});

  @override
  ConsumerState<PhrasalVerbView> createState() => _PhrasalVerbViewState();
}

class _PhrasalVerbViewState extends ConsumerState<PhrasalVerbView> {
  PhrasalVerbType phrasalVerbType = PhrasalVerbType.initial();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    phrasalVerbType =
        ModalRoute.of(context)!.settings.arguments as PhrasalVerbType;
    await ref
        .read(phrasalVerbViewModelProvider.notifier)
        .fetchPhrasalVerbList(phrasalVerbType.phrasalVerbTypeID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(phrasalVerbType.name),
      ),
      body: Column(
        children: [
          const Text('Examples'),
          ...ref
              .watch(phrasalVerbViewModelProvider)
              .phrasalVerbs
              .map((e) => Text(e.name)),
        ],
      ),
    );
  }
}
