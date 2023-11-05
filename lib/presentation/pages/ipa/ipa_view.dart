import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/domain/use_cases/firestore/progress/get_phonetic_done_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_phonetic_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/ipa/ipa_view_model.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

import 'ipa_state.dart';

final ipaViewModelProvider =
    StateNotifierProvider.autoDispose<IpaViewModel, IpaState>(
  (ref) => IpaViewModel(
    injector.get<GetPhoneticListUseCase>(),
    injector.get<GetPhoneticDoneListUseCase>(),
  ),
);

class IpaView extends ConsumerStatefulWidget {
  const IpaView({super.key});

  @override
  ConsumerState<IpaView> createState() => _IpaViewState();
}

class _IpaViewState extends ConsumerState<IpaView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  IpaViewModel get _viewModel => ref.read(ipaViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    await _viewModel.getPhoneticList();
    await _viewModel.fetchPhoneticDoneList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ipaViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(onPressed: () {
          ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
        }),
        title: Text(
          'IPA',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                child: Text(
              AppLocalizations.of(context)!.vowels,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
              ),
            )),
            Tab(
                child: Text(
              AppLocalizations.of(context)!.consonants,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
              ),
            )),
          ],
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success &&
              state.progressLoadingStatus == LoadingStatus.success
          ? TabBarView(
              controller: _tabController,
              children: [
                buildVowels(state.vowels, state.isDoneVowelList),
                buildConsonants(state.consonants, state.isDoneConsonantList),
              ],
            )
          : state.loadingStatus == LoadingStatus.error ||
                  state.progressLoadingStatus == LoadingStatus.error
              ? const AppErrorView()
              : const AppLoadingIndicator(),
    );
  }

  Widget buildVowels(List<Phonetic> vowels, List<bool> isDoneList) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
      itemCount: vowels.length,
      itemBuilder: (context, index) {
        return buildPhoneticCard(vowels[index], isDoneList[index]);
      },
    );
  }

  Widget buildConsonants(List<Phonetic> consonants, List<bool> isDoneList) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
      itemCount: 24,
      itemBuilder: (context, index) {
        return buildPhoneticCard(consonants[index], isDoneList[index]);
      },
    );
  }

  Widget buildPhoneticCard(Phonetic phonetic, bool isDone) {
    final isDarkTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          ref.read(appNavigatorProvider).navigateTo(
                AppRoutes.phonetic,
                arguments: phonetic,
              );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: ScreenUtil().setWidth(1),
            ),
            color: isDarkTheme ? Colors.grey[900] : Colors.white,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(8),
                    ),
                    Text(
                      phonetic.phonetic,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(24),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(4),
                    ),
                    Text(
                      phonetic.example.entries.first.key,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDone)
                Positioned(
                    // top right
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
