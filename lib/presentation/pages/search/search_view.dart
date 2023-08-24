import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/dictionary/get_word_list_from_search_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/search/search_state.dart';
import 'package:speak_up/presentation/pages/search/search_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
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
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          state.loadingStatus == LoadingStatus.success
              ? Flexible(
                  child: ListView.builder(
                      itemCount: state.suggestionList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.suggestionList[index]),
                        );
                      }))
              : state.loadingStatus == LoadingStatus.initial
                  ? const Expanded(
                      child: Center(
                      child: Text('Search for a word'),
                    ))
                  : state.loadingStatus == LoadingStatus.inProgress
                      ? const Expanded(child: AppLoadingIndicator())
                      : const Expanded(
                          child: Center(
                          child: Text('Error'),
                        )),
        ],
      ),
    );
  }
}
