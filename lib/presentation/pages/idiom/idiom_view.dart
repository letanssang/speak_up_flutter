import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/domain/use_cases/cloud_store/get_idiom_list_by_type_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_state.dart';
import 'package:speak_up/presentation/pages/idiom/idiom_view_model.dart';
import 'package:speak_up/presentation/utilities/common/percent_calculate.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

final idiomViewModelProvider =
    StateNotifierProvider.autoDispose<IdiomViewModel, IdiomState>(
  (ref) => IdiomViewModel(
    injector.get<GetIdiomListByTypeUseCase>(),
  ),
);

class IdiomView extends ConsumerStatefulWidget {
  const IdiomView({super.key});

  @override
  ConsumerState<IdiomView> createState() => _IdiomViewState();
}

class _IdiomViewState extends ConsumerState<IdiomView> {
  IdiomType idiomType = IdiomType.initial();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    idiomType = ModalRoute.of(context)!.settings.arguments as IdiomType;
    await ref
        .read(idiomViewModelProvider.notifier)
        .fetchIdiomList(idiomType.idiomTypeID);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomViewModelProvider);
    return Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border_outlined),
            ),
          ],
        ),
        body: state.loadingStatus == LoadingStatus.success
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: buildHeader(state),
                  ),
                  SliverAppBar(
                    toolbarHeight: ScreenUtil().setHeight(50),
                    leading: const SizedBox(),
                    pinned: true,
                    flexibleSpace: AppLinearPercentIndicator(
                      percent: state.currentIdiomIndex / state.idioms.length,
                      trailing: Text(
                        '${percentCalculate(state.currentIdiomIndex, state.idioms.length).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    elevation: 0,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index.isEven) {
                          // Add the separator logic for even indexes
                          return buildSeparator(context, state, index);
                        } else {
                          // Content for odd indexes (idiom items)
                          final idiomIndex = index ~/ 2;
                          return buildCardItem(state, idiomIndex);
                        }
                      },
                      // Double the count to include separators
                      childCount:
                          ref.watch(idiomViewModelProvider).idioms.length * 2 -
                              2,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                        height:
                            ScreenUtil().setHeight(32)), // Add desired spacing
                  ),
                ],
              )
            : const Center(
                child: AppLoadingIndicator(),
              ));
  }

  Widget buildCardItem(IdiomState state, int idiomIndex) {
    return InkWell(
      onTap: () {
        if (idiomIndex <= state.currentIdiomIndex) {
          ref.read(appNavigatorProvider).navigateTo(
                AppRoutes.idiomLearning,
                arguments: state.idioms[idiomIndex],
              );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: state.currentIdiomIndex >= idiomIndex
              ? Theme.of(context).primaryColor
              : Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(16),
                ),
                Expanded(
                  child: Text(
                    'Day ${idiomIndex + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (idiomIndex != state.currentIdiomIndex)
                  Icon(
                    idiomIndex > state.currentIdiomIndex
                        ? Icons.lock_outline
                        : Icons.check_circle_outline,
                    color: Colors.white,
                    size: ScreenUtil().setWidth(16),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.idioms[idiomIndex].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildSeparator(BuildContext context, IdiomState state, int index) {
    return Row(
      children: [
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 3,
          ),
          width: 2,
          height: 32,
          color: index ~/ 2 < state.currentIdiomIndex + 1
              ? Theme.of(context).primaryColor
              : Colors.grey, // Black color
        ),
        const Spacer(),
      ],
    );
  }

  Padding buildHeader(IdiomState state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 32,
        right: 32,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  idiomType.name,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/images/temp_topic.png',
                    fit: BoxFit.cover,
                    width: ScreenUtil().setWidth(64),
                    height: ScreenUtil().setWidth(64),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            '${state.idioms.length} Days Completed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
