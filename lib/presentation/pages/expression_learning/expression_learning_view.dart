import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/entities/sentence/sentence.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/expression_learning/expression_learning_state.dart';
import 'package:speak_up/presentation/pages/expression_learning/expression_learning_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/button_state.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final expressionLearningViewModelProvider = StateNotifierProvider.autoDispose<
        ExpressionLearningViewModel, ExpressionLearningState>(
    (ref) => ExpressionLearningViewModel(
          injector.get<SpeakFromTextUseCase>(),
        ));

class ExpressionLearningView extends ConsumerStatefulWidget {
  const ExpressionLearningView({super.key});

  @override
  ConsumerState<ExpressionLearningView> createState() =>
      _ExpressionLearningViewState();
}

class _ExpressionLearningViewState
    extends ConsumerState<ExpressionLearningView> {
  List<Sentence> sentences = [];
  final _pageController = PageController(initialPage: 0);
  ExpressionLearningViewModel get _viewModel =>
      ref.read(expressionLearningViewModelProvider.notifier);
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    sentences = ModalRoute.of(context)!.settings.arguments as List<Sentence>;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expressionLearningViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showExitBottomSheet(context);
          },
          icon: const Icon(
            Icons.close_outlined,
            size: 32,
          ),
        ),
        title: AppLinearPercentIndicator(
          percent: state.currentPage / sentences.length,
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ...sentences.map(
            (sentence) => buildExample(sentence,
                sentences.indexOf(sentence) + 1, ButtonState.normal, null),
          ),
          buildBottomMenu(
            ButtonState.normal,
          ),
        ],
      ),
    );
  }

  Widget buildExample(Sentence sentence, int sentenceIndex,
      ButtonState buttonState, Function()? onRecordButtonTap) {
    return Column(
      children: [
        SizedBox(
          height: ScreenUtil().setHeight(32),
        ),
        Text('${AppLocalizations.of(context)!.example} $sentenceIndex:',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(24),
              fontWeight: FontWeight.bold,
            )),
        Row(
          children: [
            Flexible(child: Container()),
            CustomIconButton(
              icon: Icon(
                Icons.volume_up_outlined,
                size: 32,
                color: Colors.grey[800],
              ),
              onPressed: () => _viewModel.speak(sentence.text),
            ),
            Flexible(child: Container()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            sentence.text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            sentence.translation,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              color: Colors.grey[700],
            ),
          ),
        ),
        Flexible(child: Container()),
        buildBottomMenu(buttonState),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }

  Widget buildBottomMenu(ButtonState buttonState) {
    return Row(
      children: [
        Flexible(child: Container()),
        CustomIconButton(
          onPressed: null,
          height: 64,
          width: 64,
          icon: AppIcons.playRecord(
            size: 32,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(
          width: 32,
        ),
        const RecordButton(
          onTap: null,
        ),
        const SizedBox(
          width: 32,
        ),
        CustomIconButton(
            height: 64,
            width: 64,
            onPressed: null,
            icon: Icon(
              Icons.navigate_next_outlined,
              size: 32,
              color: Colors.grey[800],
            )),
        Flexible(child: Container()),
      ],
    );
  }
}
