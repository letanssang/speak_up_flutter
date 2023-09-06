import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/use_cases/dictionary/get_word_list_from_search_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/main_menu/main_menu_view.dart';
import 'package:speak_up/presentation/pages/search/search_state.dart';
import 'package:speak_up/presentation/pages/search/search_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final searchViewModelProvider =
    StateNotifierProvider.autoDispose<SearchViewModel, SearchState>(
  (ref) => SearchViewModel(
    injector.get<GetWordListFromSearchUseCase>(),
  ),
);

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(
          onPressed: () {
            ref.read(mainMenuViewModelProvider.notifier).changeTab(0);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.dictionary,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onTapOutside: (event) {
                      focusNode.unfocus();
                    },
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      ref.read(searchViewModelProvider.notifier).onLoading();
                      _debounce =
                          Timer(const Duration(milliseconds: 500), () async {
                        await ref
                            .read(searchViewModelProvider.notifier)
                            .fetchSuggestionList(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (textEditingController.text.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        textEditingController.clear();
                        ref.read(searchViewModelProvider.notifier).onInitial();
                      },
                      icon: const Icon(
                        Icons.cancel,
                      )),
              ],
            ),
          ),
          state.loadingStatus == LoadingStatus.success
              ? Flexible(
                  child: ListView.builder(
                      itemCount: state.suggestionList.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            ref.read(appNavigatorProvider).navigateTo(
                                AppRoutes.word,
                                arguments: state.suggestionList[index]);
                          },
                          leading: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          ),
                          title: Text(
                            state.suggestionList[index],
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }))
              : state.loadingStatus == LoadingStatus.initial
                  ? Expanded(
                      child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppImages.searchSomething(
                            width: ScreenUtil().screenWidth * 0.5,
                            height: ScreenUtil().screenWidth * 0.5,
                          ),
                          const SizedBox(height: 32),
                          Text(AppLocalizations.of(context)!.searchForAWord,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ))
                  : state.loadingStatus == LoadingStatus.loading
                      ? const Expanded(child: AppLoadingIndicator())
                      : const Expanded(child: AppErrorView()),
        ],
      ),
    );
  }
}
