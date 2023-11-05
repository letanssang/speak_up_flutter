import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/domain/use_cases/local_database/get_topic_list_from_category_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/category/category_state.dart';
import 'package:speak_up/presentation/pages/category/category_view_model.dart';
import 'package:speak_up/presentation/utilities/constant/category_icon_list.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final categoryViewModelProvider =
    StateNotifierProvider.autoDispose<CategoryViewModel, CategoryState>(
  (ref) => CategoryViewModel(
    injector.get<GetTopicListByCategoryIDUseCase>(),
  ),
);

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  ConsumerState<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<CategoryView> {
  Category category = Category.initial();

  CategoryViewModel get _viewModel =>
      ref.read(categoryViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    category = ModalRoute.of(context)!.settings.arguments as Category;
    await _viewModel.fetchTopicList(category.categoryID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildBodySuccess(state.topics, isDarkTheme, language)
          : state.loadingStatus == LoadingStatus.error
              ? const AppErrorView()
              : const AppLoadingIndicator(),
    );
  }

  Widget buildBodySuccess(
      List<Topic> topics, bool isDarkTheme, Language language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryHeader(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${AppLocalizations.of(context)!.topic}:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
              )),
        ),
        _buildTopicListView(topics, isDarkTheme),
      ],
    );
  }

  Flexible _buildTopicListView(List<Topic> topics, bool isDarkTheme) {
    return Flexible(
      child: ListView.builder(
        itemCount: topics.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AppListTile(
            index: index,
            onTap: () {
              ref
                  .read(appNavigatorProvider)
                  .navigateTo(AppRoutes.topic, arguments: topics[index]);
            },
            title: topics[index].topicName,
            subtitle: topics[index].translation,
          );
        },
      ),
    );
  }

  Row _buildCategoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: categoryImageList[category.categoryID - 1],
        ),
        Column(
          children: [
            Text(category.name,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(22),
                  fontWeight: FontWeight.bold,
                )),
            Text(category.translation,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                )),
          ],
        )
      ],
    );
  }
}
