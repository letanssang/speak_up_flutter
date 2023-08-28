import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/use_cases/dictionary/get_word_detail_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/word/word_state.dart';
import 'package:speak_up/presentation/pages/word/word_view_model.dart';
import 'package:speak_up/presentation/utilities/common/convert.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';

final wordViewModelProvider = StateNotifierProvider<WordViewModel, WordState>(
  (ref) => WordViewModel(
    injector.get<GetWordDetailUseCase>(),
    injector.get<SpeakFromTextUseCase>(),
  ),
);

class WordView extends ConsumerStatefulWidget {
  const WordView({super.key});

  @override
  ConsumerState<WordView> createState() => _WordViewState();
}

class _WordViewState extends ConsumerState<WordView> {
  String word = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        _init();
      },
    );
  }

  Future<void> _init() async {
    word = ModalRoute.of(context)!.settings.arguments as String;
    setState(() {});
    ref.read(wordViewModelProvider.notifier).fetchWordDetail(word);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordViewModelProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            capitalizeFirstLetter(word),
          ),
          bottom: TabBar(isScrollable: true, tabs: [
            Tab(
              text: 'Definition',
            ),
            Tab(
              text: 'Synonym - Antonym',
            ),
            Tab(
              text: 'Family',
            ),
          ]),
        ),
        body: state.loadingStatus == LoadingStatus.success
            ? buildSuccessBody(state)
            : state.loadingStatus == LoadingStatus.loading
                ? const AppLoadingIndicator()
                : state.loadingStatus == LoadingStatus.error
                    ? Container()
                    : Container(),
      ),
    );
  }

  Widget buildSuccessBody(WordState state) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              ref.read(wordViewModelProvider.notifier).speakFromText(word);
            },
            icon: Icon(Icons.volume_up, size: 48)),
        ...state.detailWord?.pronunciation?.entries
                .map((e) => Row(
                      children: [
                        Flexible(child: Container()),
                        Text('${e.key}:',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '/${e.value}/',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(18),
                          ),
                        ),
                        Flexible(child: Container()),
                      ],
                    ))
                .toList() ??
            [],
        Flexible(
          child: ListView.builder(
              itemCount: state.detailWord?.results?.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                          state.detailWord?.results?[index].definition ?? ''),
                      subtitle: Text(
                          state.detailWord?.results?[index].partOfSpeech ?? ''),
                    ),
                  ],
                );
              }),
        ),
        // display list<string> examples
        ...state.detailWord?.examples
                ?.map((e) => ListTile(
                      title: Text(e),
                    ))
                .toList() ??
            [],
      ],
    );
  }
}
