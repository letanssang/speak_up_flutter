import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PhoneticView extends ConsumerStatefulWidget {
  const PhoneticView({super.key});

  @override
  ConsumerState<PhoneticView> createState() => _PhoneticViewState();
}

class _PhoneticViewState extends ConsumerState<PhoneticView> {
  late YoutubePlayerController _youtubePlayerController;
  Phonetic phonetic = Phonetic.initial();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    phonetic = ModalRoute.of(context)!.settings.arguments as Phonetic;
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: phonetic.youtubeVideoId,
      flags: const YoutubePlayerFlags(
          autoPlay: true,
          captionLanguage: 'vi',
          enableCaption: true,
          loop: true,
          startAt: 3),
    );
    setState(() {});
  }

  @override
  void deactivate() {
    _youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(phonetic.phonetic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            YoutubePlayer(
                controller: _youtubePlayerController,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Theme.of(context).primaryColor,
                progressColors: ProgressBarColors(
                  playedColor: Theme.of(context).primaryColor,
                  handleColor: Theme.of(context).primaryColor,
                ),
                onReady: () {
                  _youtubePlayerController.addListener(() {});
                },
                bottomActions: [
                  const SizedBox(width: 14.0),
                  CurrentPosition(),
                  const SizedBox(width: 8.0),
                  ProgressBar(
                      isExpanded: true,
                      controller: _youtubePlayerController,
                      colors: ProgressBarColors(
                        playedColor: Theme.of(context).primaryColor,
                        handleColor: Theme.of(context).primaryColor,
                      )),
                  RemainingDuration(),
                ]),
            SizedBox(
              height: 16.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  phonetic.phonetic,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.volume_up,
                      size: 32,
                    )),
              ],
            ),

            // show Map<String,String> example
            ...phonetic.example.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${entry.key}: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: RichText(
                text: TextSpan(
                  text: 'Mẹo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(18),
                    color: Theme.of(context).primaryColor,
                  ),
                  children: [
                    TextSpan(
                      text: phonetic.description,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenUtil().setSp(18),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(child: Container()),
            SafeArea(
              child: CustomButton(
                text: 'Practice now',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
