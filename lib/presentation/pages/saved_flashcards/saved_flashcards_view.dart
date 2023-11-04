import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/firestore/get_flash_card_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/saved_flashcards/saved_flashcards_state.dart';
import 'package:speak_up/presentation/pages/saved_flashcards/saved_flashcards_view_model.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/empty_view/app_empty_view.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final savedFlashCardsViewModelProvider = StateNotifierProvider.autoDispose<
        SavedFlashCarsViewModel, SavedFlashCardsState>(
    (ref) => SavedFlashCarsViewModel(
          injector.get<GetFlashCardListUseCase>(),
        ));

class SavedFlashCardsView extends ConsumerStatefulWidget {
  const SavedFlashCardsView({super.key});

  @override
  ConsumerState<SavedFlashCardsView> createState() =>
      _SavedFlashCardsViewState();
}

class _SavedFlashCardsViewState extends ConsumerState<SavedFlashCardsView> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _init();
    });
  }

  Future<void> _init() async {
    ref.read(savedFlashCardsViewModelProvider.notifier).fetchFlashCardList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(savedFlashCardsViewModelProvider);
    return state.loadingStatus == LoadingStatus.success
        ? buildLoadingSuccessfulBody(state)
        : state.loadingStatus == LoadingStatus.error
            ? const AppErrorView()
            : const AppLoadingIndicator();
  }

  Widget buildLoadingSuccessfulBody(SavedFlashCardsState state) {
    final isDarkTheme = ref.watch(themeProvider);
    return state.flashCardList.length > 1
        ? Column(
            children: [
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: state.flashCardList.length - 1,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                        child: Text(
                      formatIndexToString(index),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    title: Text(state.flashCardList[index].frontText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        )),
                    subtitle: Text(state.flashCardList[index].backText,
                        style: TextStyle(
                          color:
                              isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                        )),
                  ),
                ),
              ),
              CustomButton(
                onTap: () {
                  ref.read(appNavigatorProvider).navigateTo(
                        AppRoutes.flashCards,
                        arguments: state.flashCardList,
                      );
                },
                text: AppLocalizations.of(context)!.practiceNow,
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          )
        : const AppEmptyView();
  }
}
