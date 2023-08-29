import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

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
      body: TabBarView(
        controller: _tabController,
        children: [
          buildVowels(),
          buildConsonants(),
        ],
      ),
    );
  }

  Widget buildVowels() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
      itemCount: 20,
      itemBuilder: (context, index) {
        return buildPhoneticCard();
      },
    );
  }

  Widget buildConsonants() {
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
        return buildPhoneticCard();
      },
    );
  }

  Widget buildPhoneticCard() {
    return InkWell(
      onTap: () {
        ref.read(appNavigatorProvider).navigateTo(
              AppRoutes.phonetic,
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
              'i:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(24),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              'sheet',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
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
