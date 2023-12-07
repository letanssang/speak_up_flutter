import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_language_provider.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/category/category.dart';
import 'package:speak_up/domain/entities/lesson/lesson.dart';
import 'package:speak_up/domain/entities/youtube_video/youtube_video.dart';
import 'package:speak_up/domain/use_cases/firestore/get_flash_card_list_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/get_youtube_playlist_id_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_category_list_use_case.dart';
import 'package:speak_up/domain/use_cases/local_database/get_lesson_list_use_case.dart';
import 'package:speak_up/domain/use_cases/youtube/get_youtube_playlist_by_id_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/home/home_state.dart';
import 'package:speak_up/presentation/pages/home/home_view_model.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/constant/category_icon_list.dart';
import 'package:speak_up/presentation/utilities/enums/language.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
        (ref) => HomeViewModel(
              injector.get<GetLessonListUseCase>(),
              injector.get<GetCategoryListUseCase>(),
              injector.get<GetFlashCardListUseCase>(),
              injector.get<GetYoutubePLayListIdListUseCase>(),
              injector.get<GetYoutubePlaylistByIdUseCase>(),
            ));

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  HomeViewModel get _viewModel => ref.read(homeViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _init();
    });
  }

  Future<void> _init() async {
    await _viewModel.getCategoryList();
    await _viewModel.getLessonList();
    await _viewModel.getFlashCardList();
    await _viewModel.getYoutubeVideoLists();
  }

  String getBestThumbnailUrl(YoutubeVideoThumbnails? thumbnails) {
    return thumbnails?.maxresThumbnail?.url ??
        thumbnails?.standardThumbnail?.url ??
        thumbnails?.highThumbnail?.url ??
        thumbnails?.mediumThumbnail?.url ??
        thumbnails?.defaultThumbnail?.url ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildAppBar(),
            buildBanner(),
            buildCategories(state),
            buildExplore(state),
            buildFlashCards(state),
            buildReels(state)
          ],
        ),
      ),
    );
  }

  Widget buildFlashCards(HomeState state) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Text(
              AppLocalizations.of(context)!.review,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(appNavigatorProvider).navigateTo(
                    AppRoutes.flashCards,
                    arguments: state.flashCards,
                  );
            },
            child: Text(
              AppLocalizations.of(context)!.practiceNow,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: ScreenUtil().screenHeight * 0.25,
        child: PageView.builder(
            itemCount: state.flashCards.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final flashCard = state.flashCards[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text(flashCard.frontText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20))),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text(flashCard.backText,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: ScreenUtil().setSp(14))),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    ]);
  }

  Widget buildExplore(HomeState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                AppLocalizations.of(context)!.explore,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(appNavigatorProvider)
                    .navigateTo(AppRoutes.lessons, arguments: state.lessons);
              },
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: ScreenUtil().setSp(14),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(4),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: ScreenUtil().screenHeight < 700
                ? ScreenUtil().screenHeight * 0.4
                : ScreenUtil().screenHeight * 0.36,
          ),
          child: state.lessonsLoadingStatus == LoadingStatus.success
              ? ListView.builder(
                  itemCount: state.lessons.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      buildExploreItem(state.lessons[index]),
                )
              : Container(
                  height: ScreenUtil().scaleHeight * 0.33,
                ),
        )
      ],
    );
  }

  Widget buildExploreItem(Lesson lesson) {
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          ref
              .read(appNavigatorProvider)
              .navigateTo(AppRoutes.lesson, arguments: lesson);
        },
        child: SizedBox(
          width: ScreenUtil().screenWidth * 0.45,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isDarkTheme ? Colors.grey[850] : Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                              Image.asset(lesson.imageURL, fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Center(
                      child: Text(
                        language == Language.english
                            ? lesson.name
                            : lesson.translation,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkTheme ? Colors.white : Colors.black,
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    final user = FirebaseAuth.instance.currentUser!;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              ref.read(appNavigatorProvider).navigateTo(
                    AppRoutes.editProfile,
                  );
            },
            child: CircleAvatar(
              radius: ScreenUtil().setHeight(20),
              child: ClipOval(
                child: user.photoURL != null
                    ? Image.network(user.photoURL!)
                    : AppImages.avatar(),
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            '${AppLocalizations.of(context)!.hi} ${user.displayName}',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              ref.read(mainMenuViewModelProvider.notifier).changeTab(3);
            },
            icon: Icon(Icons.settings_outlined,
                color: Theme.of(context).iconTheme.color,
                size: ScreenUtil().setHeight(24)),
          )
        ],
      ),
    );
  }

  Widget buildCategories(HomeState state) {
    final categories = state.categories;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  AppLocalizations.of(context)!.categories,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(appNavigatorProvider)
                      .navigateTo(AppRoutes.categories, arguments: categories);
                },
                child: Text(
                  AppLocalizations.of(context)!.viewAll,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(4),
          ),
          state.categoriesLoadingStatus == LoadingStatus.success
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List<Widget>.generate(categories.length - 1,
                            (index) {
                          if (index % 2 == 0) {
                            return buildCategoryItem(categories[index], index);
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            List<Widget>.generate(categories.length, (index) {
                          if (index % 2 != 0 ||
                              index == categories.length - 1) {
                            return buildCategoryItem(categories[index], index);
                          } else {
                            return const SizedBox();
                          }
                        }),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: ScreenUtil().screenHeight * 0.15,
                ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(Category category, int index) {
    final isDarkTheme = ref.watch(themeProvider);
    final language = ref.watch(appLanguageProvider);
    return GestureDetector(
      onTap: () {
        ref
            .read(appNavigatorProvider)
            .navigateTo(AppRoutes.category, arguments: category);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(8),
            vertical: ScreenUtil().setHeight(4)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
              color: isDarkTheme ? Colors.grey[700]! : Colors.black54),
          color: isDarkTheme ? Colors.grey[800] : Colors.white,
        ),
        child: Row(
          children: [
            isDarkTheme ? categoryDarkIcons[index] : categoryIcons[index],
            const SizedBox(
              width: 3,
            ),
            Text(
              language == Language.english
                  ? category.name
                  : category.translation,
              style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                  fontSize: ScreenUtil().setSp(14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReels(HomeState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                'Reels',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(child: Container())
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(4),
        ),
        state.youtubeVideoListsLoadingStatus == LoadingStatus.success
            ? SizedBox(
                height: ScreenUtil().screenHeight * 0.3,
                child: ListView.builder(
                  itemCount: state.youtubeVideoLists.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          ref.read(appNavigatorProvider).navigateTo(
                              AppRoutes.reels,
                              arguments: state.youtubeVideoLists[index]);
                        },
                        child: AspectRatio(
                          aspectRatio: 0.65,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.black54),
                                  image: DecorationImage(
                                    image: NetworkImage(getBestThumbnailUrl(
                                        state.youtubeVideoLists[index].first
                                            .thumbnails)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom:
                                    12, // Adjust the position of the text as needed
                                left:
                                    16, // Adjust the position of the text as needed
                                right: 16,
                                child: Text(
                                  state.youtubeVideoLists[index].first.title ??
                                      '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(12),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : SizedBox(
                height: ScreenUtil().screenHeight * 0.3,
              ),
      ],
    );
  }

  Widget buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AppImages.appBanner(),
      ),
    );
  }
}
