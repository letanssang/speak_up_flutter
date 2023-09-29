import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_navigator_provider.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/presentation/navigation/app_routes.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/buttons/custom_button.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PhoneticView extends ConsumerStatefulWidget {
  const PhoneticView({super.key});

  @override
  ConsumerState<PhoneticView> createState() => _PhoneticViewState();
}

class _PhoneticViewState extends ConsumerState<PhoneticView> {
  YoutubePlayerController? _youtubePlayerController;
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
    _youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: phonetic.youtubeVideoId,
      autoPlay: true,
      startSeconds: 3,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
        loop: true,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _youtubePlayerController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(phonetic.phonetic),
      ),
      body: phonetic.youtubeVideoId.isEmpty
          ? const Center(
              child: AppLoadingIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  _youtubePlayerController == null
                      ? Container(
                          width: ScreenUtil().screenWidth - 16,
                          height: ScreenUtil().screenWidth / 16 * 9,
                          color: Colors.black,
                        )
                      : YoutubePlayer(controller: _youtubePlayerController!),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        phonetic.phonetic,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const IconButton(
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 16),
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
                      onTap: () {
                        _youtubePlayerController!.pauseVideo();
                        ref.read(appNavigatorProvider).navigateTo(
                            AppRoutes.pronunciation,
                            arguments: phonetic.phoneticID);
                      },
                      text: 'Practice now',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
