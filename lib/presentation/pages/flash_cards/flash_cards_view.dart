import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/entities/flash_card/flash_card.dart';
import 'package:speak_up/domain/use_cases/firestore/add_flash_card_use_case.dart';
import 'package:speak_up/domain/use_cases/text_to_speech/speak_from_text_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_state.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_view_model.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/complete_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/bottom_sheets/exit_bottom_sheet.dart';
import 'package:speak_up/presentation/widgets/cards/flash_card_item.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:swipable_stack/swipable_stack.dart';

final flashCardsViewModelProvider =
    StateNotifierProvider.autoDispose<FlashCardsViewModel, FlashCardsState>(
  (ref) => FlashCardsViewModel(
    injector.get<SpeakFromTextUseCase>(),
    injector.get<AddFlashCardUseCase>(),
  ),
);

class FlashCardsView extends ConsumerStatefulWidget {
  const FlashCardsView({super.key});

  @override
  ConsumerState<FlashCardsView> createState() => _FlashCardsViewState();
}

class _FlashCardsViewState extends ConsumerState<FlashCardsView> {
  List<FlashCard> flashCards = [];

  FlashCardsViewModel get _viewModel =>
      ref.read(flashCardsViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _init();
    });
  }

  Future<void> _init() async {
    flashCards = ModalRoute.of(context)!.settings.arguments as List<FlashCard>;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.init(flashCards[0].frontText);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashCardsViewModelProvider);
    ref.listen(
        flashCardsViewModelProvider.select((value) => value.currentIndex),
        (previous, next) {
      if (next == flashCards.length - 1) {
        showCompleteBottomSheet(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showExitBottomSheet(context);
          },
          icon: Icon(
            Icons.close_outlined,
            size: ScreenUtil().setHeight(24),
          ),
        ),
        title: AppLinearPercentIndicator(
          percent: flashCards.isNotEmpty
              ? state.currentIndex / flashCards.length
              : 0,
        ),
      ),
      body: flashCards.isNotEmpty
          ? buildLoadingSuccessBody(state, context)
          : const AppLoadingIndicator(),
    );
  }

  Widget buildLoadingSuccessBody(FlashCardsState state, BuildContext context) {
    final viewModel = ref.read(flashCardsViewModelProvider.notifier);
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
              if (direction == SwipeDirection.right) {
                viewModel.addFlashCard(flashCards[index]);
              }
              ref
                  .read(flashCardsViewModelProvider.notifier)
                  .speakFromText(flashCards[index + 1].frontText);
              viewModel.nextFlashCard(direction);
            },
            dragStartCurve: Curves.linearToEaseOut,
            cancelAnimationCurve: Curves.linearToEaseOut,
            horizontalSwipeThreshold: 0.8,
            verticalSwipeThreshold: 0.8,
            itemCount: flashCards.length,
            controller: viewModel.swipableStackController,
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
                      if (state.isAnimating) {
                        return;
                      }
                      viewModel.updateAnimating(true);
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        viewModel.updateAnimating(false);
                      });
                      viewModel.swipableStackController.next(
                        swipeDirection: SwipeDirection.right,
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth * 0.35,
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(16),
                      ),
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
                      if (state.isAnimating) {
                        return;
                      }
                      viewModel.updateAnimating(true);
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        viewModel.updateAnimating(false);
                      });
                      viewModel.swipableStackController.next(
                        swipeDirection: SwipeDirection.left,
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                    child: Container(
                      width: ScreenUtil().screenWidth * 0.35,
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(16),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
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
              SizedBox(
                width: ScreenUtil().screenWidth * 0.2,
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
                    fontSize: ScreenUtil().setSp(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (direction == SwipeDirection.right)
              SizedBox(
                width: ScreenUtil().screenWidth * 0.2,
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
          frontText: flashCards[index].frontText,
          backText: flashCards[index].backText,
          tapFrontDescription: AppLocalizations.of(context)!.tapToSeeTheMeaning,
          tapBackDescription: AppLocalizations.of(context)!.tapToReturn,
          backTranslation: flashCards[index].backTranslation ?? '',
          onPressedFrontCard: () {
            ref
                .read(flashCardsViewModelProvider.notifier)
                .speakFromText(flashCards[index].frontText);
          },
          onPressedBackCard: () {
            ref
                .read(flashCardsViewModelProvider.notifier)
                .speakFromText(flashCards[index].backText);
          }),
    );
  }
}
