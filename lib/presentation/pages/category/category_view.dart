import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _CategoryViewState extends ConsumerState<CategoryView> {
  Category? category;

  @override
  void initState() {
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
      appBar: AppBar(
        title: category != null ? Text(category!.name) : null,
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildBodySuccess(state.topics, isDarkTheme, language)
          : state.loadingStatus == LoadingStatus.error
              ? buildBodyError()
              : buildBodyInProgress(),
    );
  }

  Widget buildBodySuccess(
      List<Topic> topics, bool isDarkTheme, Language language) {
    return Center(
      child: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.topic, arguments: topics[index]);
              },
              child: Card(
                  elevation: 5,
                  color: isDarkTheme ? Colors.grey[850] : Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/temp_topic.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language == Language.english
                                ? topics[index].topicName
                                : topics[index].translation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
        },
      ),
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
