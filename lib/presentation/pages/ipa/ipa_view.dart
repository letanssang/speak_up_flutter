import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_phonetic_list_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/ipa/ipa_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

import 'ipa_state.dart';

final IpaViewModelProvider = StateNotifierProvider<IpaViewModel, IpaState>(
  (ref) => IpaViewModel(
    injector.get<GetPhoneticListUseCase>(),
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
    await ref.read(IpaViewModelProvider.notifier).getPhoneticList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(IpaViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('IPA'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Vowels',
            ),
            Tab(
              text: 'Consonants',
            ),
          ],
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? TabBarView(
              controller: _tabController,
              children: [
                buildVowels(state.vowels),
                buildConsonants(state.consonants),
              ],
            )
          : state.loadingStatus == LoadingStatus.error
              ? const Center(
                  child: Text('Error'),
                )
              : const AppLoadingIndicator(),
    );
  }

  Widget buildVowels(List<Phonetic> vowels) {
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
        return buildPhoneticCard(vowels[index]);
      },
    );
  }

  Widget buildConsonants(List<Phonetic> consonants) {
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
        return buildPhoneticCard(consonants[index]);
      },
    );
  }

  Widget buildPhoneticCard(Phonetic phonetic) {
    return InkWell(
      onTap: () {
        ref.read(appNavigatorProvider).navigateTo(
              AppRoutes.phonetic,
              arguments: phonetic,
            );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              phonetic.phonetic,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(24),
                color: Theme.of(context).primaryColor,
              ),
            ),
            AppLinearPercentIndicator(
              percent: 0.2,
              lineHeight: ScreenUtil().setHeight(6),
              progressColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.only(top: 8),
            ),
          ],
        ),
      ),
    );
  }
}
