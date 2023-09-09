import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/use_cases/local_database/get_word_list_by_phonetic_id_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_state.dart';
import 'package:speak_up/presentation/pages/pronunciation/pronunciation_view_model.dart';
import 'package:speak_up/presentation/resources/app_icons.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:speak_up/presentation/widgets/buttons/record_button.dart';
import 'package:speak_up/presentation/widgets/error_view/app_error_view.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

final pronunciationViewModelProvider = StateNotifierProvider.autoDispose<
    PronunciationViewModel, PronunciationState>(
  (ref) => PronunciationViewModel(
    injector.get<GetWordListByPhoneticIDUSeCase>(),
  ),
);

class PronunciationView extends ConsumerStatefulWidget {
  const PronunciationView({super.key});

  @override
  ConsumerState<PronunciationView> createState() => _PronunciationViewState();
}

class _PronunciationViewState extends ConsumerState<PronunciationView> {
  int phoneticID = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    phoneticID = ModalRoute.of(context)!.settings.arguments as int;
    await ref
        .read(pronunciationViewModelProvider.notifier)
        .fetchWordList(phoneticID);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> onNextButtonTap() async {
    if (_pageController.page?.toInt() ==
        ref.watch(pronunciationViewModelProvider).wordList.length - 1) {
      showCompleteBottomSheet(context);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pronunciationViewModelProvider);
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
        title: const AppLinearPercentIndicator(
          percent: 0,
        ),
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.wordList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                state.wordList[index].word,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                state.wordList[index].pronunciation,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                buildBottomMenu(),
                const SizedBox(height: 64),
              ],
            )
          : state.loadingStatus == LoadingStatus.loading
              ? const AppLoadingIndicator()
              : const AppErrorView(),
    );
  }

  Row buildBottomMenu() {
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
          //buttonState: buttonState,
          onTap: null,
        ),
        const SizedBox(
          width: 32,
        ),
        CustomIconButton(
            height: 64,
            width: 64,
            onPressed: () {
              onNextButtonTap();
            },
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
