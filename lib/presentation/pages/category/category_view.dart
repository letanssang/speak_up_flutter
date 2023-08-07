import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/category/category_state.dart';
import 'package:speak_up/presentation/pages/category/category_view_model.dart';
import 'package:speak_up/presentation/utilities/constant/categories.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final categoryViewModelProvider =
    StateNotifierProvider.autoDispose<CategoryViewModel, CategoryState>(
  (ref) => CategoryViewModel(
    injector.get<GetTopicListFromCategoryUseCase>(),
  ),
);

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  ConsumerState<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView>
    with TickerProviderStateMixin {
  Category? category;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final categoryIndex = ModalRoute.of(context)!.settings.arguments as int;
    category = categories[categoryIndex];
    await ref
        .read(categoryViewModelProvider.notifier)
        .fetchTopicList(category!.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(),
      body: state.loadingStatus == LoadingStatus.success
          ? buildBodySuccess(state.topics, isDarkTheme, language)
          : state.loadingStatus == LoadingStatus.error
              ? buildBodyError()
              : buildBodyInProgress(),
    );
  }

  Widget buildBodySuccess(
      List<Topic> topics, bool isDarkTheme, Language language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Image.asset(
            'assets/images/temp_topic.png',
            width: double.infinity,
            height: ScreenUtil().screenHeight * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(category!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.grey[350]),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.zero,
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(
                icon: Text(
                  'About',
                ),
              ),
              Tab(
                icon: Text('Topics'),
              ),
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(),
              ListView.builder(
                itemCount: topics.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 5,
                      color: isDarkTheme ? Colors.grey[850] : Colors.white,
                      surfaceTintColor: Colors.white,
                      child: ListTile(
                        onTap: () {
                          ref.read(appNavigatorProvider).navigateTo(
                              AppRoutes.topic,
                              arguments: topics[index]);
                        },
                        title: Text(
                          topics[index].topicName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          topics[index].translation,
                          style: const TextStyle(
                            fontSize: 14,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBodyInProgress() {
    return const Center(
      child: AppLoadingIndicator(),
    );
  }

  Widget buildBodyError() {
    return const Center(
      child: Text('Something went wrong!'),
    );
  }
}
