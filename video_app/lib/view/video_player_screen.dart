import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/utils/utils.dart';
import 'package:video_app/view_model/video_player_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  late Animation<double> iconAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    ));

    Provider.of<VideoPlayerProvider>(
      context,
      listen: false,
    ).initVideoPlayer(widget.videoUrl);

    super.initState();
  }

  @override
  void dispose() {
    Provider.of<VideoPlayerProvider>(
      context,
      listen: false,
    ).dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player Screen"),
        centerTitle: true,
      ),
      body: Consumer<VideoPlayerProvider>(
        builder: (context, playerProvider, child) {
          if (playerProvider.isLoading) {
            return customCircularProgressIndicator();
          }

          _videoPlayerController = playerProvider.videoPlayerController;

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 60,
                    width: screenWidth(context),
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.keyboard_double_arrow_left_rounded,
                          size: 50,
                        ),
                        IconButton(
                          onPressed: () {
                            if (_videoPlayerController.value.isPlaying) {
                              playerProvider.pausePlayer();
                              _animationController.forward();
                            } else {
                              playerProvider.playPlayer();
                              _animationController.reverse();
                            }
                          },
                          icon: AnimatedIcon(
                            progress: iconAnimation,
                            icon: AnimatedIcons.pause_play,
                            size: 50,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
