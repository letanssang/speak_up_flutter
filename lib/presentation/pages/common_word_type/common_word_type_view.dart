import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/use_cases/local_database/get_common_word_list_by_type.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/common_word_type/common_word_type_state.dart';
import 'package:speak_up/presentation/pages/common_word_type/common_word_type_view_model.dart';
import 'package:speak_up/presentation/utilities/constant/alphabet_list.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/list_tiles/app_list_tile.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/search_bars/app_search_bar.dart';

final commonWordTypeViewModelProvider = StateNotifierProvider.autoDispose<
    CommonWordTypeViewModel, CommonWordTypeState>(
  (ref) => CommonWordTypeViewModel(
    injector.get<GetCommonWordListByTypeUseCase>(),
    injector.get<SpeakFromTextUseCase>(),
  ),
);

class CommonWordTypeView extends ConsumerStatefulWidget {
  const CommonWordTypeView({super.key});

  @override
  ConsumerState<CommonWordTypeView> createState() => _CommonWordTypeViewState();
}

class _CommonWordTypeViewState extends ConsumerState<CommonWordTypeView> {
  int type = 0;

  CommonWordTypeViewModel get _viewModel =>
      ref.read(commonWordTypeViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    type = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {});
    await _viewModel.fetchCommonWordList(type + 1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commonWordTypeViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${AppLocalizations.of(context)?.wordStartWith} ${alphabetList[type]}',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? _buildLoadingSuccessBody(state, isDarkTheme)
          : state.loadingStatus == LoadingStatus.error
              ? const AppErrorView()
              : const AppLoadingIndicator(),
    );
  }

  Widget _buildLoadingSuccessBody(CommonWordTypeState state, bool isDarkTheme) {
    return Column(
      children: [
        AppSearchBar(
          onInitial: _viewModel.onSearchInitial,
          onLoading: _viewModel.onSearchLoading,
          onSearch: _viewModel.onSearch,
          isDarkTheme: isDarkTheme,
        ),
        Expanded(
          child: state.searchLoadingStatus == LoadingStatus.success
              ? ListView.builder(
                  itemCount: state.suggestionList.length,
                  itemBuilder: (context, index) {
                    final commonWord = state.suggestionList[index];
                    return AppListTile(
                      index: index,
                      title: commonWord.commonWord,
                      subtitle: commonWord.translation,
                      leading: _buildLeadingListTile(commonWord.commonWord),
                      trailing: _buildTrailingListTile(
                        commonWord.partOfSpeech,
                        commonWord.level,
                        isDarkTheme,
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: state.commonWordList.length,
                  itemBuilder: (context, index) {
                    final commonWord = state.commonWordList[index];
                    return AppListTile(
                      index: index,
                      title: commonWord.commonWord,
                      subtitle: commonWord.translation,
                      leading: _buildLeadingListTile(commonWord.commonWord),
                      trailing: _buildTrailingListTile(commonWord.partOfSpeech,
                          commonWord.level, isDarkTheme),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLeadingListTile(String index) {
    return CircleAvatar(
        child: IconButton(
      onPressed: () {
        _viewModel.speak(index);
      },
      icon: Icon(
        Icons.volume_up_outlined,
        color: Theme.of(context).primaryColor,
      ),
    ));
  }

  Widget _buildTrailingListTile(
      String partOfSpeech, String level, bool isDarkTheme) {
    return Text('$partOfSpeech - $level',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? Colors.white : Theme.of(context).primaryColor,
        ));
  }
}
