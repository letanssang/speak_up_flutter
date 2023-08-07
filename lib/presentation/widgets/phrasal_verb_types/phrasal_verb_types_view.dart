import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phrasal_verb_type_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/phrasal_verb_types/phrasal_verb_types_state.dart';
import 'package:speak_up/presentation/widgets/phrasal_verb_types/phrasal_verb_types_view_model.dart';

final phrasalVerbTypesViewModelProvider = StateNotifierProvider.autoDispose<
    PhrasalVerbTypesViewModel, PhrasalVerbTypesState>(
  (ref) => PhrasalVerbTypesViewModel(
    injector.get<GetPhrasalVerbTypeListUseCase>(),
  ),
);

class PhrasalVerbTypesView extends ConsumerStatefulWidget {
  const PhrasalVerbTypesView({super.key});

  @override
  ConsumerState<PhrasalVerbTypesView> createState() =>
      _PhrasalVerbTypesViewState();
}

class _PhrasalVerbTypesViewState extends ConsumerState<PhrasalVerbTypesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    await ref
        .read(phrasalVerbTypesViewModelProvider.notifier)
        .getPhrasalVerbList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phrasalVerbTypesViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    switch (state.loadingStatus) {
      case LoadingStatus.success:
        return ListView.builder(
          itemCount: state.phrasalVerbTypes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 3,
                color: isDarkTheme ? Colors.grey[850] : Colors.white,
                surfaceTintColor: Colors.white,
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    state.phrasalVerbTypes[index].name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.play_circle_outline_outlined,
                    size: 32,
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
        return const Center(child: Text('Error'));
      default:
        return const Center(child: AppLoadingIndicator());
    }
  }
}
