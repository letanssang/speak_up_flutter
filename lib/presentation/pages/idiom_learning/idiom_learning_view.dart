import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/domain/use_cases/audio_player/play_audio_from_url_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_state.dart';
import 'package:speak_up/presentation/pages/idiom_learning/idiom_learning_view_model.dart';
import 'package:speak_up/presentation/widgets/percent_indicator/app_linear_percent_indicator.dart';

final idiomLearningViewModelProvider = StateNotifierProvider.autoDispose<
    IdiomLearningViewModel, IdiomLearningState>(
  (ref) => IdiomLearningViewModel(
    injector.get<PlayAudioFromUrlUseCase>(),
  ),
);

class IdiomLearningView extends ConsumerStatefulWidget {
  const IdiomLearningView({super.key});

  @override
  ConsumerState<IdiomLearningView> createState() => _IdiomLearningViewState();
}

class _IdiomLearningViewState extends ConsumerState<IdiomLearningView> {
  Idiom idiom = Idiom.initial();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
  }

  Future<void> _init() async {
    idiom = ModalRoute.of(context)!.settings.arguments as Idiom;
    ref.read(idiomLearningViewModelProvider.notifier).setIdiom(idiom);
    ref
        .read(idiomLearningViewModelProvider.notifier)
        .playAudio(idiom.audioEndpoint);
  }

  void showPopDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('All progress will be lost.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(appNavigatorProvider).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(idiomLearningViewModelProvider);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: showPopDialog,
            icon: const Icon(
              Icons.close_outlined,
            ),
          ),
          title: const AppLinearPercentIndicator(
            percent: 0.5,
          )),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(32),
            ),
            FlipCard(
              speed: 300,
              front: buildFrontCard(context, state),
              back: buildBackCard(context, state),
            )
          ],
        ),
      ),
    );
  }

  Card buildBackCard(BuildContext context, IdiomLearningState state) {
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: ScreenUtil().screenWidth * 0.8,
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tap to see the idiom',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                )),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    state.idiom.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  ref
                      .read(idiomLearningViewModelProvider.notifier)
                      .playAudio(idiom.audioEndpoint);
                },
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: ScreenUtil().setWidth(32),
                )),
          ],
        ),
      ),
    );
  }

  Card buildFrontCard(BuildContext context, IdiomLearningState state) {
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: ScreenUtil().screenWidth * 0.8,
        width: ScreenUtil().screenWidth * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tap to see the meaning',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                )),
            Expanded(
              child: Center(
                child: Text(
                  state.idiom.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  ref
                      .read(idiomLearningViewModelProvider.notifier)
                      .playAudio(idiom.audioEndpoint);
                },
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: ScreenUtil().setWidth(32),
                )),
          ],
        ),
      ),
    );
  }
}
