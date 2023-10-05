import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/local_database/get_tense_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/tenses/tenses_state.dart';
import 'package:speak_up/presentation/pages/tenses/tenses_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final tensesViewModelProvider =
    StateNotifierProvider.autoDispose<TensesViewModel, TensesState>(
  (ref) => TensesViewModel(
    injector.get<GetTenseListUseCase>(),
  ),
);

class TensesView extends ConsumerStatefulWidget {
  const TensesView({super.key});

  @override
  ConsumerState<TensesView> createState() => _TensesViewState();
}

class _TensesViewState extends ConsumerState<TensesView> {
  TensesViewModel get _viewModel => ref.watch(tensesViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    await _viewModel.getTenseList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tensesViewModelProvider);
    return state.loadingStatus == LoadingStatus.success
        ? _buildLoadingSuccessBody(state)
        : state.loadingStatus == LoadingStatus.error
            ? const AppErrorView()
            : const AppLoadingIndicator();
  }

  Widget _buildLoadingSuccessBody(TensesState state) {
    final language = ref.watch(appLanguageProvider);
    return ListView.builder(
      itemCount: state.tenses.length,
      itemBuilder: (context, index) {
        final tense = state.tenses[index];
        return AppListTile(
          onTap: () {
            ref
                .read(appNavigatorProvider)
                .navigateTo(AppRoutes.tense, arguments: tense);
          },
          index: index,
          title: language == Language.english ? tense.tense : tense.translation,
        );
      },
    );
  }
}
