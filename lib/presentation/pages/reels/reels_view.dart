import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:speak_up/domain/entities/youtube_video/youtube_video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ReelsView extends ConsumerStatefulWidget {
  const ReelsView({super.key});

  @override
  ConsumerState<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends ConsumerState<ReelsView> {
  late final PreloadPageController preloadPageController;
  late final List<YoutubeVideo> videos;
  final Map<int, YoutubePlayerController> youtubeControllers = {};

  YoutubePlayerController createNewYoutubeController(
      String videoID, int index) {
    final youtubeController = YoutubePlayerController.fromVideoId(
      videoId: videoID,
      autoPlay: index == 0,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        loop: true,
        color: 'black',
      ),
    );
    youtubeControllers[index] = youtubeController;
    return youtubeController;
  }

  @override
  void initState() {
    super.initState();
    preloadPageController = PreloadPageController();
    Future.delayed(
      Duration.zero,
      () => _init(),
    );
  }

  Future<void> _init() async {
    videos = ModalRoute.of(context)!.settings.arguments as List<YoutubeVideo>;
    setState(() {});
  }

  @override
  void dispose() {
    youtubeControllers.forEach((key, value) {
      value.close();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          buildReelsBody(),
          // back button
          Positioned(
            // plus padding top status bar
            top: MediaQuery.of(context).padding.top + 32,
            left: 10,
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
              child: CircleAvatar(
                radius: ScreenUtil().setHeight(22),
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: ScreenUtil().setHeight(20),
                    color: Colors.black,
                  ),
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReelsBody() {
    return PreloadPageView.builder(
      controller: preloadPageController,
      preloadPagesCount: 1,
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      onPageChanged: (index) {
        //remove all controllers except current index and next index
        youtubeControllers.forEach((key, value) {
          if (key != index && key != index - 1 && key != index + 1) {
            value.close();
          }
          if (key != index) value.pauseVideo();
        });
        youtubeControllers[index]?.playVideo();
      },
      itemBuilder: (context, index) {
        final youtubeController = createNewYoutubeController(
            videos[index].resourceId?.videoId ?? '', index);
        return Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  ScreenUtil().screenHeight * 0.1),
          child: YoutubePlayer(
            aspectRatio: 9 / 16,
            controller: youtubeController,
            enableFullScreenOnVerticalDrag: false,
          ),
        );
      },
    );
  }
}
