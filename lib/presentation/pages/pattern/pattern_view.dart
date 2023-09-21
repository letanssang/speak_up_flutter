import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/pattern/sentence_pattern.dart';
import 'package:speak_up/domain/use_cases/local_database/get_sentence_list_from_pattern_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_state.dart';
import 'package:speak_up/presentation/pages/pattern/pattern_view_model.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

final patternViewModelProvider =
    StateNotifierProvider.autoDispose<PatternViewModel, PatternState>(
        (ref) => PatternViewModel(
              injector.get<GetSentenceListFromPatternUseCase>(),
            ));

class PatternView extends ConsumerStatefulWidget {
  const PatternView({super.key});

  @override
  ConsumerState<PatternView> createState() => _PatternViewState();
}

class _PatternViewState extends ConsumerState<PatternView> {
  SentencePattern pattern = SentencePattern.initial();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    pattern = ModalRoute.of(context)!.settings.arguments as SentencePattern;
    ref
        .read(patternViewModelProvider.notifier)
        .fetchExampleList(pattern.patternID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patternViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(pattern.name),
      ),
      body: Column(children: [
        Text(pattern.youtubeVideoID ?? ''),
        Text(pattern.description),
        Text(pattern.descriptionTranslation),
        const Text('Examples'),
        ...state.sentenceExamples.map((e) => Text(e.text)),
        const Text('Dialogues'),
        Text(pattern.dialogue),
      ]),
    );
  }
}
