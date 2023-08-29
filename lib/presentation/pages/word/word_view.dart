import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/entities/word_definition/word_definition.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          capitalizeFirstLetter(word),
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildSuccessBody(state)
          : state.loadingStatus == LoadingStatus.loading
              ? const AppLoadingIndicator()
              : state.loadingStatus == LoadingStatus.error
                  ? Container()
                  : Container(),
    );
  }

  Widget buildSuccessBody(WordState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.detailWord?.pronunciation is String)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '/${state.detailWord?.pronunciation}/',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(18),
                  ),
                ),
              ),
            if (state.detailWord?.pronunciation is Map)
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
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                ref
                    .read(wordViewModelProvider.notifier)
                    .changeExpandedList(index, isExpanded);
              },
              expandedHeaderPadding: const EdgeInsets.all(8),
              children: [
                ...?state.detailWord?.results
                    ?.map((e) => ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return buildWordDefinitionItem(e);
                          },
                          body: buildExpansionBody(e),
                          isExpanded: state.isExpandedList[
                              state.detailWord!.results!.indexOf(e)],
                        ))
                    .toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpansionBody(WordDefinition wordDefinition) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16, bottom: 32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPairInformation('Synonyms', wordDefinition.synonyms,
                'Antonyms', wordDefinition.antonyms),
            buildPairInformation('Type of', wordDefinition.typeOf, 'Has types',
                wordDefinition.hasTypes),
            buildPairInformation('Member of', wordDefinition.memberOf,
                'Has members', wordDefinition.hasMembers),
            buildPairInformation('Part of', wordDefinition.partOf, 'Has parts',
                wordDefinition.hasParts),
            buildPairInformation('Instance of', wordDefinition.instanceOf,
                'Has instances', wordDefinition.hasInstances),
            buildPairInformation('Similar to', wordDefinition.similarTo, 'Also',
                wordDefinition.also),
            buildPairInformation('Substance of', wordDefinition.hasSubstances,
                'Has substances', wordDefinition.substanceOf),
            buildPairInformation('In category', wordDefinition.inCategory,
                'Has categories', wordDefinition.hasCategories),
            buildPairInformation('Usage of', wordDefinition.usageOf,
                'Has usages', wordDefinition.hasUsages),
            buildPairInformation('In region', wordDefinition.inRegion,
                'Region of', wordDefinition.regionOf),
            buildPairInformation('Pertains to', wordDefinition.pertainsTo,
                'Entails', wordDefinition.entails),
            if (wordDefinition.examples != null)
              Text(
                'Examples:',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            if (wordDefinition.examples != null)
              const SizedBox(
                height: 8,
              ),
            if (wordDefinition.examples != null)
              ...wordDefinition.examples!
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: Colors.grey[800],
                          ),
                        ),
                      ))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget buildPairInformation(
      String title1, List<String>? list1, String title2, List<String>? list2) {
    return Column(
      children: [
        if (list1 != null) buildRichText(title1, list1.join(', ')),
        if (list2 != null) buildRichText(title2, list2.join(', ')),
        if (list1 != null || list2 != null)
          const SizedBox(
            height: 8,
          ),
      ],
    );
  }

  Widget buildRichText(String title, String content) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              color: Colors.black, // You can set your desired text color
            ),
            children: [
              TextSpan(
                text: '$title: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: content),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWordDefinitionItem(WordDefinition wordDefinition) {
    final index = ref
        .read(wordViewModelProvider)
        .detailWord!
        .results!
        .indexOf(wordDefinition);
    return ListTile(
      title: Text('${formatIndexToString(index)}. ${wordDefinition.definition}',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          )),
      subtitle: Text(wordDefinition.partOfSpeech ?? '',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
