import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_state.dart';
import 'package:speak_up/presentation/pages/flash_cards/flash_cards_view_model.dart';
import 'package:speak_up/presentation/utilities/enums/flash_card_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/flash_card_item/flash_card_item.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';
import 'package:swipable_stack/swipable_stack.dart';

final flashCardsViewModelProvider =
    StateNotifierProvider.autoDispose<FlashCardsViewModel, FlashCardsState>(
  (ref) => FlashCardsViewModel(
    injector.get<GetIdiomListByTypeUseCase>(),
  ),
);

class FlashCardsView extends ConsumerStatefulWidget {
  const FlashCardsView({super.key});

  @override
  ConsumerState<FlashCardsView> createState() => _FlashCardsViewState();
}

class _FlashCardsViewState extends ConsumerState<FlashCardsView> {
  late final FlashCardType flashCardType;
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
    flashCardType = args['flashCardType'] as FlashCardType;
    parentType = args['parent'];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(flashCardsViewModelProvider.notifier)
          .init(flashCardType, parentType);
      await ref.read(flashCardsViewModelProvider.notifier).fetchFlashCards();
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
          title: AppLinearPercentIndicator(
            percent: state.loadingStatus == LoadingStatus.success
                ? state.currentIndex / state.flashCards.length
                : 0,
          ),
        ),
        body: state.loadingStatus == LoadingStatus.success
            ? buildLoadingSuccessBody(state, context)
            : state.loadingStatus == LoadingStatus.inProgress
                ? const Center(child: AppLoadingIndicator())
                : const Center(child: Text('Something went wrong')));
  }

  Widget buildLoadingSuccessBody(FlashCardsState state, BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SwipableStack(
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
              const SizedBox(
                height: 32,
              ),
              Flexible(child: Container()),
              Row(
                children: [
                  Flexible(child: Container()),
                  Container(
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
                      'Review later',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
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
                      'I got it',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )),
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

  Widget buildCurrentFlashCardItem(FlashCardsState state, int index) {
    return Padding(
      padding: EdgeInsets.only(
          top: 32,
          left: 16,
          right: 16,
          bottom: ScreenUtil().screenHeight * 0.3),
      child: FlashCardItem(
          flashCardSize: FlashCardSize.large,
          frontText: state.flashCards[index].frontText,
          backText: state.flashCards[index].backText,
          tapFrontDescription: 'tap',
          tapBackDescription: 'tap',
          backTranslation: state.flashCards[index].backTranslation ?? ''),
    );
  }
}
