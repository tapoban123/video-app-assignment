import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_app/view_model/firebase_services_provider.dart';
import 'package:video_app/view_model/media_picker_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

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

    File videoFile = File(Provider.of<MediaPickerProvider>(
      context,
      listen: false,
    ).videoPath!);

    _videoPlayerController = VideoPlayerController.file(videoFile);
    _videoPlayerController.initialize().then(
      (value) {
        setState(() {});
      },
    );
    _videoPlayerController.play();

    _videoPlayerController.addListener(
      () {
        if (_videoPlayerController.value.isCompleted) {
          _animationController.forward();
          _animationController.reset();
        }
      },
    );

    Provider.of<FirebaseServicesProvider>(context, listen: false).uploadFile(
      fileName: "VideoFile1.mp4",
      videoFile: videoFile.path,
    );

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
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
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ),
            Positioned.fill(
              child: Container(
                height: 100,
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
                          _videoPlayerController.pause();
                          _animationController.forward();
                        } else {
                          _videoPlayerController.play();
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
      ),
    );
  }
}
