import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/pages/saved_flashcards/saved_flashcards_view.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/empty_view/app_empty_view.dart';
import 'package:speak_up/presentation/widgets/tab_bars/app_tab_bar.dart';

class SavedView extends ConsumerStatefulWidget {
  const SavedView({super.key});

  @override
  ConsumerState<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends ConsumerState<SavedView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
            },
          ),
        ),
        body: Column(
          children: [
            AppTabBar(
              tabController: _tabController,
              titleTab1: AppLocalizations.of(context)!.saved,
              titleTab2: 'Flashcards',
            ),
            Flexible(
              fit: FlexFit.loose,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AppEmptyView(),
                  SavedFlashCardsView(),
                ],
              ),
            ),
          ],
        ));
  }
}
