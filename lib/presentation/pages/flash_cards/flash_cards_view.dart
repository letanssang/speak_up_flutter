import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_state.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/cards/flash_card_item.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:swipable_stack/swipable_stack.dart';

final flashCardsViewModelProvider =
    StateNotifierProvider.autoDispose<FlashCardsViewModel, FlashCardsState>(
  (ref) => FlashCardsViewModel(
    injector.get<GetIdiomListByTypeUseCase>(),
    injector.get<SpeakFromTextUseCase>(),
  ),
);

class FlashCardsView extends ConsumerStatefulWidget {
  const FlashCardsView({super.key});

  @override
  ConsumerState<FlashCardsView> createState() => _FlashCardsViewState();
}

class _FlashCardsViewState extends ConsumerState<FlashCardsView> {
  late final LessonType _lessonType;
  late final dynamic parentType;
  final _swipableStackController = SwipableStackController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _init();
    });
  }

  Future<void> _init() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _lessonType = args['lessonType'] as LessonType;
    parentType = args['parent'];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(flashCardsViewModelProvider.notifier)
          .init(_lessonType, parentType);
      await ref.read(flashCardsViewModelProvider.notifier).fetchFlashCards();

      await ref.read(flashCardsViewModelProvider.notifier).speakFromText(
          ref.read(flashCardsViewModelProvider).flashCards[0].frontText);
    });
    _swipableStackController.addListener(() {
      ref
          .read(flashCardsViewModelProvider.notifier)
          .updateCurrentIndex(_swipableStackController.currentIndex);
    });
  }

  @override
  void dispose() {
    _swipableStackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashCardsViewModelProvider);
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
          percent: state.loadingStatus == LoadingStatus.success
              ? state.currentIndex / state.flashCards.length
              : 0,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_up_outlined),
          ),
        ],
      ),
      body: state.loadingStatus == LoadingStatus.success
          ? buildLoadingSuccessBody(state, context)
          : state.loadingStatus == LoadingStatus.error
              ? const Center(child: Text('Something went wrong'))
              : const Center(child: AppLoadingIndicator()),
    );
  }

  Widget buildLoadingSuccessBody(FlashCardsState state, BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SwipableStack(
            overlayBuilder: (context, swipeProperty) {
              return Center(
                child: swipeProperty.direction == SwipeDirection.left
                    ? buildOverlayText(
                        Colors.green,
                        AppLocalizations.of(context)!.iGotIt,
                        SwipeDirection.left,
                      )
                    : buildOverlayText(
                        Colors.red,
                        AppLocalizations.of(context)!.reviewLater,
                        SwipeDirection.right,
                      ),
              );
            },
            onSwipeCompleted: (index, direction) {
              ref
                  .read(flashCardsViewModelProvider.notifier)
                  .speakFromText(state.flashCards[index + 1].frontText);
            },
            dragStartCurve: Curves.linearToEaseOut,
            cancelAnimationCurve: Curves.linearToEaseOut,
            horizontalSwipeThreshold: 0.8,
            verticalSwipeThreshold: 0.8,
            itemCount: state.flashCards.length,
            controller: _swipableStackController,
            swipeAnchor: SwipeAnchor.bottom,
            detectableSwipeDirections: const {
              SwipeDirection.right,
              SwipeDirection.left,
            },
            builder: ((context, swipeProperty) {
              return buildCurrentFlashCardItem(state, swipeProperty.index);
            }),
          ),
        ),
        Center(
          child: Column(
            children: [
              Flexible(child: Container()),
              Row(
                children: [
                  Flexible(child: Container()),
                  InkWell(
                    onTap: () {
                      _swipableStackController.next(
                        swipeDirection: SwipeDirection.right,
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth * 0.35,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)!.reviewLater,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      _swipableStackController.next(
                        swipeDirection: SwipeDirection.left,
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      height: 64,
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)!.iGotIt,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                  Flexible(child: Container()),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOverlayText(Color color, String text, SwipeDirection direction) {
    return Column(
      children: [
        SizedBox(
          height: ScreenUtil().screenHeight * 0.2,
        ),
        Row(
          children: [
            Flexible(
              child: Container(),
            ),
            if (direction == SwipeDirection.left)
              const SizedBox(
                width: 128,
              ),
            Transform.rotate(
              angle: direction == SwipeDirection.left ? 0.1 : -0.1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 5,
                    color: color,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (direction == SwipeDirection.right)
              const SizedBox(
                width: 64,
              ),
            Flexible(
              child: Container(),
            ),
          ],
        ),
        Flexible(
          child: Container(),
        ),
      ],
    );
  }

  Widget buildCurrentFlashCardItem(FlashCardsState state, int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().screenHeight * 0.1,
          left: 16,
          right: 16,
          bottom: ScreenUtil().screenHeight * 0.2),
      child: FlashCardItem(
          flashCardSize: FlashCardSize.large,
          frontText: state.flashCards[index].frontText,
          backText: state.flashCards[index].backText,
          tapFrontDescription: AppLocalizations.of(context)!.tapToSeeTheMeaning,
          tapBackDescription: _lessonType.getTapBackDescription(context),
          backTranslation: state.flashCards[index].backTranslation ?? '',
          onPressedFrontCard: () {
            ref
                .read(flashCardsViewModelProvider.notifier)
                .speakFromText(state.flashCards[index].frontText);
          },
          onPressedBackCard: () {
            ref
                .read(flashCardsViewModelProvider.notifier)
                .speakFromText(state.flashCards[index].backText);
          }),
    );
  }
}
