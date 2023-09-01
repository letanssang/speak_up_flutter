import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:speak_up/presentation/widgets/buttons/app_back_button.dart';
import 'package:speak_up/presentation/widgets/loading_indicator/app_loading_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ReelsView extends ConsumerStatefulWidget {
  const ReelsView({super.key});

  @override
  ConsumerState<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends ConsumerState<ReelsView> {
  List<String> videoIDs = ['cdIzCt7HOXk', 'PX8ag5BqYPE', 'RTJUmIvgIkQ'];
  List<YoutubePlayerController>? youtubePlayerControllers;
  late final PreloadPageController preloadPageController;

  void changeVideo(int index) {
    youtubePlayerControllers![index].play();
    //pause previous video
    if (index > 0) {
      youtubePlayerControllers![index - 1].pause();
    }
    //pause next video
    if (index < youtubePlayerControllers!.length - 1) {
      youtubePlayerControllers![index + 1].pause();
    }
  }

  @override
  void initState() {
    super.initState();
    preloadPageController = PreloadPageController();
    youtubePlayerControllers = videoIDs
        .map(
          (videoID) => YoutubePlayerController(
            initialVideoId: videoID,
            flags: YoutubePlayerFlags(
              disableDragSeek: true,
              hideControls: true,
              hideThumbnail: true,
              //auto play first video
              autoPlay: videoIDs.indexOf(videoID) == 0,
              captionLanguage: 'en',
              enableCaption: true,
              loop: true,
              startAt: 0,
            ),
          ),
        )
        .toList();
    preloadPageController.addListener(() {
      final index = preloadPageController.page!.round();
      if (preloadPageController.page! - index == 0.0) {
        changeVideo(index);
      }
    });
  }

  void deactivate() {
    youtubePlayerControllers?.forEach((controller) => controller.pause());
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerControllers?.forEach((controller) => controller.dispose());
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
            top: MediaQuery.of(context).padding.top,
            left: 10,
            child: const AppBackButton(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReelsBody() {
    if (youtubePlayerControllers == null)
      return const Center(child: AppLoadingIndicator());
    return PreloadPageView.builder(
      controller: preloadPageController,
      preloadPagesCount: 1,
      scrollDirection: Axis.vertical,
      itemCount: videoIDs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 32),
          child: YoutubePlayer(
            aspectRatio: 9 / 16,
            controller: youtubePlayerControllers![index],
            topActions: [],
            bottomActions: [],
          ),
        );
      },
    );
  }
}
