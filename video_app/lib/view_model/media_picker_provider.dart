import 'package:flutter/material.dart';
import 'package:video_app/services/media_picker.dart';

/// Provider that allows the UI to access the mediaPicker services.
class MediaPickerProvider extends ChangeNotifier {
  String? _videoPath;
  bool _isLoading = false;

  String? get videoPath => _videoPath;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> selectVideo() async {
    setLoading(true);
    _videoPath = await pickVideo();
    setLoading(false);
  }
}
