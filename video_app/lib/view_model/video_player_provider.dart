import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerProvider extends ChangeNotifier {
  late VideoPlayerController _videoPlayerController;
  bool _isLoading = true;

  // if (_isLoading == false) {
  //   _setLoading(true);
  // }

  void resetProvider() {
    _isLoading = true;
  }

  bool get isLoading => _isLoading;

  VideoPlayerController get videoPlayerController => _videoPlayerController;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void initVideoPlayer(String videoUrl) async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoPlayerController.initialize();
    _setLoading(false);
  }

  void pausePlayer() {
    _videoPlayerController.pause();
    notifyListeners();
  }

  void playPlayer() {
    _videoPlayerController.play();
    notifyListeners();
  }

  void seek10SecondsForward() {
    final Duration currentPosition = _videoPlayerController.value.position;
    final Duration targetPosition = currentPosition + Duration(seconds: 10);

    _videoPlayerController.seekTo(targetPosition);
    notifyListeners();
  }

  void seek10SecondsBackward() {
    final Duration currentPositon = _videoPlayerController.value.position;
    final Duration targetPosition = currentPositon - Duration(seconds: 10);
    _videoPlayerController.seekTo(targetPosition);
    notifyListeners();
  }
}
